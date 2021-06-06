import 'package:flutter/material.dart';

import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/lyric_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: ChangeNotifierProvider.value(
        value: WorshipRepository(),
        child: Consumer<WorshipRepository>(
          builder: (context, worship, child) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Semana 21/03 a 26/03'),
                      Divider(color: Colors.black),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                worship.list == null
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: worship.list.length,
                        itemBuilder: (context, index) =>
                            LyricCard(worship.list[index]),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
