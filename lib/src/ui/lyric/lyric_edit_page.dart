import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

// ignore: must_be_immutable
class LyricEditPage extends StatelessWidget {
  static const routeName = 'lyric_edit';
  var titleFieldController = TextEditingController();
  var stanzaFieldController = TextEditingController();
  var chorusFieldController = TextEditingController();
  var styleFieldController = TextEditingController();
  var toneFieldController = TextEditingController();
  var linkFieldController = TextEditingController();
  var lyric = LyricModel();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scafoldKey = GlobalKey<ScaffoldState>();

    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    lyric = args.objParam as LyricModel;

    titleFieldController.text = lyric.title;
    stanzaFieldController.text = lyric.stanza;
    chorusFieldController.text = lyric.chorus;
    styleFieldController.text = StringHelper.listToString(lyric.style);
    toneFieldController.text = lyric.tone;
    linkFieldController.text = lyric.videoUrl;

    return Scaffold(
      key: scafoldKey,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Consumer<LyricRepository>(
            builder: (context, repo, __) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _titleFormField(),
                    _stanzaFormField(),
                    _chorusFormField(),
                    _styleFormField(),
                    _toneFormField(),
                    _linkFormField(),
                    SizedBox(height: 20.0),
                    repo.loading
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                  child: Text('  SALVAR  '),
                                  onPressed: () {
                                    if (!formKey.currentState.validate())
                                      return;
                                    formKey.currentState.save();
                                    repo.save(lyric,
                                        onSucess: (id) {
                                          lyric.id = id;
                                          customSnackBar(context,
                                              'Música atualizada com sucesso.');
                                        },
                                        onError: (err) =>
                                            errorSnackBar(context, err));
                                  }),
                              SizedBox(width: 10.0),
                              ElevatedButton(
                                child: Text('ANEXAR PDF'),
                                onPressed: () {
                                  repo.uploadPdf(lyric,
                                      onSucess: (e) => customSnackBar(
                                          context, 'PDF anexado com sucesso.'),
                                      onError: (err) =>
                                          errorSnackBar(context, err));
                                },
                              ),
                            ],
                          ),
                    // _saveTextButtom(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _titleFormField() {
    return TextFormField(
      controller: titleFieldController,
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.validTitle,
      decoration: InputDecoration(
        labelText: 'Título da música',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.title = value,
    );
  }

  Widget _stanzaFormField() {
    return TextFormField(
      controller: stanzaFieldController,
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.validStanza,
      decoration: InputDecoration(
        labelText: 'Primeira estrofe',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.stanza = value,
    );
  }

  Widget _chorusFormField() {
    return TextFormField(
      controller: chorusFieldController,
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.validChorus,
      decoration: InputDecoration(
        labelText: 'Início do coro',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.chorus = value,
    );
  }

  Widget _styleFormField() {
    return TextFormField(
      controller: styleFieldController,
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.validStyle,
      decoration: InputDecoration(
        labelText: 'Tema/estilo',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.style = value.toUpperCase().split(','),
    );
  }

  Widget _toneFormField() {
    return TextFormField(
      controller: toneFieldController,
      autocorrect: false,
      enableSuggestions: false,
      validator: (value) => validTone(value) ? null : Constants.validTone,
      decoration: InputDecoration(
        labelText: 'Tom da música',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.tone = value,
    );
  }

  Widget _linkFormField() {
    return TextFormField(
      controller: linkFieldController,
      autofillHints: [AutofillHints.url],
      autocorrect: false,
      validator: (value) =>
          validVideoUrl(value) ? null : Constants.validVideoUrl,
      decoration: InputDecoration(
        labelText: 'Link do video',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.videoUrl = value,
    );
  }
}