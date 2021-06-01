import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/lyric_item.dart';

class LyricListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LyricRepository>(
      builder: (context, repo, child) {
        List lyrics = repo.lyrics;
        return Scaffold(
          appBar: CustomAppBar(),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Músicas cadastradas'),
                      Divider(color: Colors.black),
                      SizedBox(height: 20.0),
                      Card(
                        margin: EdgeInsets.all(0.0),
                        child: LyricItem(lyrics, page: 'lyric'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
