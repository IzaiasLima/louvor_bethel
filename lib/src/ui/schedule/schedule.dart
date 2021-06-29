import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
// import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/worship/lyric_select.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  static const routeName = 'schedule';
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final fmt = DateFormat("dd/MM/yyyy HH:mm");
  TextEditingController descController;
  TextEditingController dateTimeController;
  DateTime initValue;
  Worship worship;

  @override
  void initState() {
    // worship = Worship();
    descController = TextEditingController();
    dateTimeController = TextEditingController();
    initValue = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    final worship = args.objParam as Worship;
    final formKey = GlobalKey<FormState>();
    final DateFormat fmt = DateFormat().addPattern("EEEE, dd/MM H'h'mm");
    String evento = '${fmt.format(worship.dateTime)} - ${worship.description}';

    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringHelper.capitalize(evento),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('Escala de músicos'),
                _leadSingerFormField(),
                _backingVocalsFormField(),

                _keyboardFormField(),
                _acoustGuitarFormField(),
                _guitarFormField(),
                _bassFormField(),
                _drumsFormField(),
                _backupMusicianFormField(),
                _backupVocalFormField(),

                // Container(
                //     alignment: Alignment.topLeft,
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //     child: worship.songs == null
                //         ? Text('Ainda não há músicas selecionadas.',
                //             style: TextStyle(color: Colors.red))
                //         : Container(
                //             height: (worship.songs.length * 50.0),
                //             child: Text('Músicos'),
                //  ReorderableListView(
                //   children: worship.songs
                //       .map((song) => ListTile(
                //             key: ValueKey(song),
                //             dense: true,
                //             minLeadingWidth: 0.1,
                //             horizontalTitleGap: 0.0,
                //             leading: Icon(Icons.music_note),
                //             title: Text('${song['title']}'),
                //           ))
                //       .toList(),
                //   onReorder: null,
                // ),
                // )),
                // TextButton(
                //     child: Row(
                //       children: [
                //         Icon(Icons.add),
                //         Text('Adicionar músicas'),
                //       ],
                //     ),
                //     onPressed: () async {
                //       formKey.currentState.save();
                //       await _selLyrics(context, worship).then((value) {
                //         setState(() {
                //           // worship = value;
                //           initValue = worship.dateTime;
                //           dateTimeController.text =
                //               fmt.format(worship.dateTime);
                //           descController.text = worship.description;
                //         });
                //       });
                //     }),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: ElevatedButton(
                    onPressed: () {},
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

  Future<Worship> _selLyrics(context, Worship worship) async {
    List<Map<String, dynamic>> sel = [];
    worship.songs = [];

    final List<LyricModel> result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => LyricSelect(),
      ),
    );
    result.forEach((l) => sel.add(l.toBasicMap()));
    worship.songs.addAll(sel);
    return worship;
  }

  _guitarFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Guitarrista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _bassFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Baixista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _acoustGuitarFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Violonista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _keyboardFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Tecladista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _drumsFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Baterista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _backupMusicianFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Músico reserva',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _leadSingerFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Ministro de louvor',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _backingVocalsFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Back vocais',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }

  _backupVocalFormField() {
    return TextFormField(
      controller: descController,
      autocorrect: true,
      // autofocus: true,
      decoration: InputDecoration(
        labelText: 'Cantor reserva',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: (value) =>
          validWorshipField(value) ? null : Constants.validDescription,
      onSaved: (value) => worship.description = value,
    );
  }
}
