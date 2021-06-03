import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

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
                    _tonePassFormField(),
                    Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: repo.viewState == ViewState.Busy
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              child: Text('CADASTRAR'),
                              onPressed: () {
                                if (!formKey.currentState.validate()) {
                                  return;
                                }
                                formKey.currentState.save();

                                repo.save(
                                  newLyric: lyric,
                                  onSucess: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar(
                                      'Música cadastrada com sucesso.',
                                      color: Theme.of(context).primaryColor,
                                    ));
                                    Navigator.of(context)
                                        .popAndPushNamed('lyric_list');
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

  Widget _titleTextField() {
    return TextFormField(
      autofillHints: [AutofillHints.name],
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
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
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

  Widget _tonePassFormField() {
    return TextFormField(
      // controller: confirmPassdController,
      autocorrect: false,
      validator: (value) => validTone(value) ? null : Constants.validTone,
      decoration: InputDecoration(
        labelText: 'Tom da música',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) => lyric.tone = value,
    );
  }
}
