import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/commons/datetime_helper.dart';
import 'package:provider/provider.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_card.dart';
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
        child: Consumer<WorshipRepository>(
          builder: (_, repo, __) {
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
                        Text(DateTimeHelper.getWeek()),
                        Divider(color: Colors.black),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  repo.loading
                      ? CircularProgressIndicator()
                      : (repo.worships != null && repo.worships.length > 0)
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: repo.worships.length,
                              itemBuilder: (context, index) =>
                                  LyricCard(repo.worships[index]),
                            )
                          : Container(
                              child: Text('Não havia dados para exibir.'),
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
