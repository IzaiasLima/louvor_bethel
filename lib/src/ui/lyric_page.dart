import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/enum/states.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/repositories/lyric_repository.dart';

class LyricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LyricRepository repo = Provider.of<LyricRepository>(context);
    repo.get();

    return repo.viewState == ViewState.Busy
        ? CircularProgressIndicator()
        : (repo.lyrics != null)
            ? ListView.builder(
                itemCount: repo.lyrics.lenght,
                itemBuilder: (BuildContext context, index) {
                  return ListTile(
                    title: repo.lyrics[index].title,
                  );
                })
            : Container(child: Text('sss'));
  }
}
