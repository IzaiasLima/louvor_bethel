import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/models/schedule.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';

// ignore: must_be_immutable
class SchedulePage extends StatefulWidget {
  static const routeName = 'schedule';
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  var leadSingerController = TextEditingController();
  var backingVocalsController = TextEditingController();
  var keyboardController = TextEditingController();
  var acoustGuitarController = TextEditingController();
  var guitarController = TextEditingController();
  var bassController = TextEditingController();
  var drumsController = TextEditingController();
  var backupMusicianController = TextEditingController();
  var backupVocalController = TextEditingController();

  Worship worship;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    worship = args.objParam as Worship;
    final formKey = GlobalKey<FormState>();
    final DateFormat fmt = DateFormat().addPattern("EEEE, dd/MM H'h'mm");

    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      worship.schedule = Schedule.fromText(value.text);

      leadSingerController.text = worship.schedule.leadSinger;
      backingVocalsController.text = worship.schedule.backingVocals;
      keyboardController.text = worship.schedule.keyboard;
      acoustGuitarController.text = worship.schedule.acoustGuitar;
      guitarController.text = worship.schedule.guitar;
      bassController.text = worship.schedule.bass;
      drumsController.text = worship.schedule.drums;
      backupMusicianController.text = worship.schedule.backupMusician;
      backupVocalController.text = worship.schedule.backupVocal;
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringHelper.capitalize(fmt.format(worship.dateTime)),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text('${worship.description}'),
                _leadSingerFormField(),
                _backingVocalsFormField(),
                _keyboardFormField(),
                _guitarFormField(),
                _acoustGuitarFormField(),
                _bassFormField(),
                _drumsFormField(),
                _backupMusicianFormField(),
                _backupVocalsFormField(),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: ElevatedButton(
                    onPressed: () {
                      formKey.currentState.save();
                      context.read<WorshipRepository>().update(worship);
                      Navigator.of(context).pop();
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

  _leadSingerFormField() {
    return TextFormField(
      controller: leadSingerController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Ministro de louvor',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.leadSinger = value,
    );
  }

  _guitarFormField() {
    return TextFormField(
      controller: guitarController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Guitarrista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.guitar = value,
    );
  }

  _bassFormField() {
    return TextFormField(
      controller: bassController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Baixista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.bass = value,
    );
  }

  _acoustGuitarFormField() {
    return TextFormField(
      controller: acoustGuitarController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Violonista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.acoustGuitar = value,
    );
  }

  _keyboardFormField() {
    return TextFormField(
      controller: keyboardController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Tecladista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.keyboard = value,
    );
  }

  _drumsFormField() {
    return TextFormField(
      controller: drumsController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Baterista',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.drums = value,
    );
  }

  _backupMusicianFormField() {
    return TextFormField(
      controller: backupMusicianController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Músico reserva',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.backupMusician = value,
    );
  }

  _backingVocalsFormField() {
    return TextFormField(
      controller: backingVocalsController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Backvocais',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.backingVocals = value,
    );
  }

  _backupVocalsFormField() {
    return TextFormField(
      controller: backupVocalController,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: 'Cantor reserva',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => worship.schedule.backupVocal = value,
    );
  }
}
