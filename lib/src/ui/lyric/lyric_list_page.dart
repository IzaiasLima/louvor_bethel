import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_itens.dart';

class LyricListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LyricRepository>(builder: (_, repo, __) {
          return repo.search.isEmpty
              ? Text(Constants.title)
              : Text('${repo.search}');
        }),
        actions: [
          searchLyrics(context),
        ],
      ), // CustomAppBar(),
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
                    child: LyricItens(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
