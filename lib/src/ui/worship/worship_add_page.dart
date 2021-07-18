import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/worship/lyric_select.dart';

// ignore: must_be_immutable
class WorshipAddPage extends StatefulWidget {
  static const routeName = 'worship_add';

  @override
  _WorshipAddPageState createState() => _WorshipAddPageState();
}

class _WorshipAddPageState extends State<WorshipAddPage> {
  final fmt = DateFormat("dd/MM/yyyy HH:mm");
  var descriptionController = TextEditingController();
  var dateTimeController = TextEditingController();
  var worship = Worship()
    ..dateTime = DateTime.now()
    ..description = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    var worshipReceived = args?.objParam as Worship;
    worship = worshipReceived ?? worship;
    descriptionController.text = worship.description;
    dateTimeController.text = fmt.format(worship.dateTime);

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
                        ),
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
                    await _selLyrics(context, worship).then((sel) {
                      worship.songs = [];
                      worship.songs.addAll(sel);
                    });
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: ElevatedButton(
                    child: Text('CADASTRAR'),
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
      if (newindex > oldindex) newindex -= 1;
      final song = worship.songs.removeAt(oldindex);
      worship.songs.insert(newindex, song);
    });
  }

  Future<List<Map<String, dynamic>>> _selLyrics(
      context, Worship worship) async {
    List<Map<String, dynamic>> sel = [];

    final List<Lyric> result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => LyricSelect(),
      ),
    );
    result.forEach((l) => sel.add(l.toBasicMap()));
    return sel;
  }

  _dateTimeFormfield() {
    return DateTimeField(
      controller: dateTimeController,
      initialValue: worship.dateTime,
      decoration: InputDecoration(
        labelText: 'Data e hora do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipDateTime(value) ? null : Constants.validDateTime,
      onSaved: (dateTime) => worship.dateTime = dateTime,
      format: fmt,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
          confirmText: 'OK',
          context: context,
          firstDate: DateTime.now(),
          initialDate: worship.dateTime,
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
      controller: descriptionController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Nome do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }
}
