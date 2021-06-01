import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

class LyricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  Text('Detalhe'),
                  Divider(color: Colors.black),
                  SizedBox(height: 20.0),
                  FutureProvider<LyricModel>(
                    initialData: null,
                    create: (context) =>
                        LyricRepository().lyricById('1JF5YPwrIjXg35GegAXL'),
                    builder: (_, child) => Consumer<LyricModel>(
                      builder: (context, value, child) =>
                          Text('Música: ${value.title} '),
                    ),
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
