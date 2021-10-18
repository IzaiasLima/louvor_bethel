// import 'dart:ffi';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:louvor_bethel/src/commons/datetime_helper.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List<Worship> worships;
  bool listAll = false;
  int weekOfset = 0;

  Future refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      var repo = context.read<WorshipRepository>();
      worships = listAll ? repo.worships : repo.refreshList(weekOfset);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Pressione de novo para sair.'),
        ),
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: Consumer<WorshipRepository>(
            builder: (_, repo, __) {
              worships =
                  listAll ? repo.worships : repo.getWeekWorships(weekOfset);
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onDoubleTap: onDoubleTap,
                            onHorizontalDragEnd: onHorizontalDragEnd,
                            child: LayoutBuilder(
                              builder: (_, constrains) {
                                return Container(
                                  width: constrains.maxWidth,
                                  child: listAll
                                      ? Text('Lista geral (todos os eventos)')
                                      : Text(DateTimeHelper.getTxtWeek(
                                          offset: weekOfset)),
                                );
                              },
                            ),
                          ),
                          Divider(color: Colors.black),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    repo.loading
                        ? CircularProgressIndicator()
                        : (worships != null && worships.length > 0)
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: worships.length,
                                itemBuilder: (context, index) =>
                                    LyricCard(worships[index]),
                              )
                            : Container(
                                child: Text('Sem eventos nesta semana.'),
                              ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity > 1.0) {
        weekOfset--;
      } else if (details.primaryVelocity < -1.0) {
        weekOfset++;
      }
    });
  }

  void onDoubleTap() {
    setState(() => listAll = !listAll);
  }
}
