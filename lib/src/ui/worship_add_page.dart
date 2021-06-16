import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/ui/lyric_select.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

// ignore: must_be_immutable
class WorshipAddPage extends StatelessWidget {
  Worship worship = Worship();

  WorshipAddPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Consumer<WorshipRepository>(
            builder: (_, repo, __) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _descriptionFormField(),
                    _dateTimeFormfield(),
                    TextButton(
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text('Incluir músicas'),
                          ],
                        ),
                        onPressed: () async {
                          await _addLyrics(context).then(
                            (value) => worship.lyrics.addAll(value),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState.validate())
                            return;
                          else {
                            formKey.currentState.save();
                            // worship.lyrics = [];
                            worship.userId =
                                context.read<UserManager>().user.id;
                            repo.save(worship);
                          }
                        },
                        child: Text('CADASTRAR'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<LyricModel>> _addLyrics(context) async {
    final List<LyricModel> result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => LyricSelect(),
      ),
    );
    return result;
  }

  _dateTimeFormfield() {
    final format = DateFormat("dd-MM-yyyy HH:mm");
    return DateTimeField(
      decoration: InputDecoration(
        labelText: 'Data e hora do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipDate(value) ? null : Constants.validTime,
      onSaved: (dateTime) => worship.dateTime = dateTime,
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    );
  }

  _descriptionFormField() {
    return TextFormField(
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Evento / momento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }
}
