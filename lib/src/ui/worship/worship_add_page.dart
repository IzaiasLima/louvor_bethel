import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  TextEditingController dateController;
  TextEditingController timeController;
  DateTime initialDate;
  DateTime worshipTime;
  TimeOfDay initialTime;
  Worship worship;

  @override
  void initState() {
    worship = Worship();
    descController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    initialDate = DateTime.now();
    initialTime = TimeOfDay.now();
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
                // _dateTimeFormfield(),
                _dateFormField(),
                _timeFormField(),
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
                      worship = await _selLyrics(context, worship);
                      //.then((value) {
                      //final s = value.songs;
                      setState(() {
                        // worship.songs.addAll(s);
                        // worship = value;
                        //   // initialDate = worship.dateTime;
                        //   // dateController.text = fmt.format(worship.dateTime);
                        //   // descController.text = worship.description;
                        // });
                      });
                    }),
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

  _dateFormField() {
    // DateTime _dateTime;
    return TextFormField(
      keyboardType: TextInputType.datetime,
      validator: (_) =>
          validWorshipDate(worship.dateTime) ? null : Constants.validDateTime,
      autofocus: false,
      readOnly: true,
      controller: dateController,
      onSaved: ((_) => worship.dateTime = worshipTime),
      onTap: () async {
        worshipTime = await showDatePicker(
            context: context,
            confirmText: 'OK',
            initialDate: initialDate,
            firstDate: initialDate,
            lastDate: initialDate.add(Duration(days: 180)));
        setState(() => {
              dateController.text =
                  DateFormat('dd/MM/yyyy').format(worshipTime),
              // worship.dateTime = worshipTime,
            });
      },
      decoration: InputDecoration(
        labelText: 'Data do evento',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        icon: Icon(
          Icons.date_range,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _timeFormField() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      validator: (value) =>
          validWorshipTime(value) ? null : Constants.validDateTime,
      autofocus: false,
      readOnly: true,
      controller: timeController,
      onTap: () async {
        final _time = await showTimePicker(
          context: context,
          initialTime: initialTime,
          confirmText: 'OK',
        );
        setState(() => {
              timeController.text = _time.format(context),
              worship.dateTime = _combine(worshipTime, _time),
            });
      },
      decoration: InputDecoration(
        labelText: 'Hora do evento',
        icon: Icon(
          Icons.watch_later_outlined,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // _dateTimeFormfield() {
  //   return DateTimeField(
  //     controller: dateTimeController,
  //     initialValue: initialDate,
  //     decoration: InputDecoration(
  //       labelText: 'Data e hora do evento',
  //       floatingLabelBehavior: FloatingLabelBehavior.auto,
  //     ),
  //     validator: (value) =>
  //         validWorshipDate(value) ? null : Constants.validTime,
  //     onSaved: (dateTime) => worship.dateTime = dateTime,
  //     format: fmt,
  //     onShowPicker: (context, currentValue) async {
  //       final date = await showDatePicker(
  //         confirmText: 'OK',
  //         context: context,
  //         firstDate: DateTime.now(),
  //         initialDate: currentValue ?? initialDate,
  //         lastDate: DateTime.now().add(Duration(days: 180)),
  //       );
  //       if (date != null) {
  //         final time = await showTimePicker(
  //           confirmText: 'OK',
  //           context: context,
  //           initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
  //         );
  //         return DateTimeField.combine(date, time);
  //       } else {
  //         return currentValue;
  //       }
  //     },
  //   );
  // }

  DateTime _combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  _descriptionFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      autofocus: true,
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
