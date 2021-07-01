import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/worship/lyric_select.dart';

// ignore: must_be_immutable
class WorshipAddPage extends StatefulWidget {
  @override
  _WorshipAddPageState createState() => _WorshipAddPageState();
}

class _WorshipAddPageState extends State<WorshipAddPage> {
  final fmt = DateFormat("dd/MM/yyyy HH:mm");
  TextEditingController descController;
  TextEditingController dateTimeController;
  DateTime initValue;
  Worship worship;

  @override
  void initState() {
    worship = Worship();
    descController = TextEditingController();
    dateTimeController = TextEditingController();
    initValue = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _descriptionFormField(),
                _dateTimeFormfield(),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: worship.songs == null
                        ? Text('Ainda não há músicas selecionadas.',
                            style: TextStyle(color: Colors.red))
                        : Container(
                            height: (worship.songs.length * 50.0),
                            child: ReorderableListView(
                              children: worship.songs
                                  .map((song) => ListTile(
                                        key: ValueKey(song),
                                        dense: true,
                                        minLeadingWidth: 0.1,
                                        horizontalTitleGap: 0.0,
                                        leading: Icon(Icons.music_note),
                                        title: Text('${song['title']}'),
                                      ))
                                  .toList(),
                              onReorder: reorderSongs,
                            ),
                          )
                    // : worship.songs
                    //     .map((s) => ListTile(
                    //           minLeadingWidth: 0.1,
                    //           dense: true,
                    //           leading: Icon(Icons.music_note),
                    //           title: Text('${s['title']}'),
                    //         ))
                    //     .toList(),
                    // ),
                    ),
                TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text('Adicionar músicas'),
                      ],
                    ),
                    onPressed: () async {
                      formKey.currentState.save();
                      await _selLyrics(context, worship).then((value) {
                        setState(() {
                          worship = value;
                          initValue = worship.dateTime;
                          dateTimeController.text =
                              fmt.format(worship.dateTime);
                          descController.text = worship.description;
                        });
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: ElevatedButton(
                    onPressed: () {
                      final repo = context.read<WorshipRepository>();
                      if (!formKey.currentState.validate() ||
                          worship.songs == null)
                        return;
                      else {
                        formKey.currentState.save();
                        worship.userId = context.read<UserManager>().user.id;
                        repo.save(worship);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('CADASTRAR'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reorderSongs(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final song = worship.songs.removeAt(oldindex);
      worship.songs.insert(newindex, song);
    });
  }

  Future<Worship> _selLyrics(context, Worship worship) async {
    List<Map<String, dynamic>> sel = [];
    worship.songs = [];

    final List<Lyric> result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => LyricSelect(),
      ),
    );
    result.forEach((l) => sel.add(l.toBasicMap()));
    worship.songs.addAll(sel);
    return worship;
  }

  _dateTimeFormfield() {
    return DateTimeField(
      controller: dateTimeController,
      initialValue: initValue,
      decoration: InputDecoration(
        labelText: 'Data e hora do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipDate(value) ? null : Constants.validTime,
      onSaved: (dateTime) => worship.dateTime = dateTime,
      format: fmt,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          confirmText: 'OK',
          context: context,
          firstDate: DateTime.now(),
          initialDate: currentValue ?? initValue,
          lastDate: DateTime.now().add(Duration(days: 180)),
        );
        if (date != null) {
          final time = await showTimePicker(
            confirmText: 'OK',
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
      controller: descController,
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
