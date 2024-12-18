import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

// ignore: must_be_immutable
class LyricAddPage extends StatelessWidget {
  Lyric lyric = Lyric();

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
          child: Consumer<LyricRepository>(
            builder: (_, repo, __) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _titleTextField(),
                    _stanzaTextField(),
                    _chorusFormField(),
                    _styleFormField(),
                    _toneFormField(),
                    _linkTextField(),
                    _buttons(context, formKey, repo),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buttons(context, formKey, LyricRepository repo) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: (repo.progress > 0 && repo.progress < 100)
          ? Center(
              child: CircularStepProgressIndicator(
                totalSteps: 100,
                currentStep: repo.progress,
                stepSize: 7,
                selectedColor: Constants.darkGray,
                unselectedColor: Constants.grayColor,
                width: 60,
                height: 60,
                selectedStepSize: 7,
                roundedCap: (_, __) => true,
              ),
            )
          : Wrap(
              children: [
                if (lyric.id != null && lyric.hasPdf)
                  ElevatedButton(
                    child: Text('LISTAR'),
                    onPressed: () =>
                        Navigator.of(context).popAndPushNamed('lyric_list'),
                  ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  child: lyric.id == null
                      ? Text('CADASTRAR')
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.upload_outlined), Text('PDF')],
                        ),
                  onPressed: () {
                    if (repo.isLoading) return null;
                    if (!formKey.currentState.validate()) return;
                    formKey.currentState.save();

                    if (lyric.id == null) {
                      repo.save(
                        lyric,
                        onSucess: (id) {
                          lyric.id = id;
                          customSnackBar(
                              context, 'Música cadastrada com sucesso.');
                        },
                        onError: (err) => errorSnackBar(context, '$err'),
                      );
                    } else {
                      repo.uploadPdf(lyric,
                          onSucess: (_) {},
                          onError: (err) => errorSnackBar(context, '$err'));
                    }
                  },
                ),
              ],
            ),
    );
  }

  Widget _titleTextField() {
    return TextFormField(
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

  Widget _stanzaTextField() {
    return TextFormField(
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
      autocorrect: true,
      validator: (value) =>
          validLyricField(value) ? null : Constants.validStyle,
      decoration: InputDecoration(
        labelText: 'Tema/estilo',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (value) =>
          lyric.styles = StringHelper.toSlash(value).toUpperCase(),
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
}
