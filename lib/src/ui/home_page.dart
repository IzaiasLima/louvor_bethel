import 'package:flutter/material.dart';

import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/lyric_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Worship adoracao = WorshipRepository.adoracao();
    Worship oferta = WorshipRepository.oferta();

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Consumer<WorshipRepository>(builder: (context, repo, __) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                child: Column(
                  children: [
                    Text('Semana 21/03 a 26/03'),
                    Divider(color: Colors.black),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              LyricCard(adoracao),
              LyricCard(oferta),
            ],
          );
        }),
      ),
    );
  }
}
