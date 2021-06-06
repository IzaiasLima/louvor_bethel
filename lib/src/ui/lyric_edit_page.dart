import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

// ignore: must_be_immutable
class LyricEditPage extends StatelessWidget {
  LyricModel lyric = LyricModel();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scafoldKey = GlobalKey<ScaffoldState>();

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
                    _titleTextField(),
                    _stanzaTextField(),
                    _chorusFormField(),
                    _styleFormField(),
                    _toneFormField(),
                    _linkTextField(),
                    (lyric.id != null) ? _pdfTextField() : Text(''),
                    Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: repo.viewState == ViewState.Busy
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text(
                                  lyric.id == null ? 'CADASTRAR' : 'ATUALIZAR'),
                              onPressed: () {
                                if (!formKey.currentState.validate()) return;

                                formKey.currentState.save();

                                repo.saveLyric(
                                  newLyric: lyric,
                                  onSucess: (id) {
                                    lyric.id = id;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar(
                                      'Música cadastrada com sucesso.',
                                      color: Theme.of(context).primaryColor,
                                    ));
                                    // Navigator.of(context)
                                    //     .popAndPushNamed('lyric_list');
                                  },
                                  onError: (e) => ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar(e)),
                                );
                              },
                            ),
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

  Widget _pdfTextField() {
    return TextFormField(
      autocorrect: false,
      enabled: true,
      validator: (value) => validLyricField(value) ? null : Constants.validPdf,
      decoration: InputDecoration(
        labelText: 'Pdf com a Cifra',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onTap: () {
        print('**************');
      },
      onSaved: (value) => lyric..pdfUrl = value,
    );
  }

  Widget _linkTextField() {
    return TextFormField(
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

  Widget _titleTextField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.neededTitle,
      decoration: InputDecoration(
        labelText: 'Título da música',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.title = value,
    );
  }

  Widget _stanzaTextField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.neededStanza,
      decoration: InputDecoration(
        labelText: 'Primeira estrofe',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.stanza = value,
    );
  }

  Widget _chorusFormField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.neededChorus,
      decoration: InputDecoration(
        labelText: 'Início do coro',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.chorus = value,
    );
  }

  Widget _styleFormField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.neededStyle,
      decoration: InputDecoration(
        labelText: 'Tema/estilo',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.style = value.split(','),
    );
  }

  Widget _toneFormField() {
    return TextFormField(
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
}
