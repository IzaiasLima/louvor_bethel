import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/lyric_card.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Pressione de novo para sair.'),
        ),
        child: Consumer<LyricRepository>(
          builder: (context, repo, child) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Semana 25/06 a 31/06'),
                        Divider(color: Colors.black),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  repo.viewState == ViewState.Busy
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: repo.worships.length,
                          itemBuilder: (context, index) =>
                              LyricCard(repo.worships[index]),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
