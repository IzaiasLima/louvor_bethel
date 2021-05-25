import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/src/models/auth_model.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/models/worship_provider.dart';
import 'package:louvor_bethel/src/shared/constants.dart';
import 'package:louvor_bethel/src/shared/string_helper.dart';
import 'package:louvor_bethel/src/ui/shared/base_view.dart';
import 'package:louvor_bethel/src/ui/shared/drawer.dart';
import 'package:louvor_bethel/src/ui/shared/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      builder: (context, model, __) => Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: userAvatar(model, 22),
            )
          ],
          titleSpacing: 0.0,
          title: Text(Constants.title), //Text('***LOUVOR BETHEL'),
        ),
        body: (model.user == null)
            ? expiredSessionCard(model)
            : SingleChildScrollView(
                child: Column(
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
                    FutureBuilder(
                      future: WorshipProvider.adoracao(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _Card(snapshot.data);
                        } else {
                          return Container(height: 0.0);
                        }
                      },
                    ),
                    FutureBuilder(
                      future: WorshipProvider.oferta(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _Card(snapshot.data);
                        } else {
                          return Container(height: 0.0);
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Worship worship;
  final capitalize = StringHelper.capitalize;
  final DateFormat dia = DateFormat().addPattern("EEEE H'h'm");

  _Card(this.worship);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                circleAvatar(worship.userAvatar, 20),
                SizedBox(width: 8.0),
                Text(
                  capitalize(dia.format(worship.dateTime)),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                Text(worship.description),
              ],
            ),
            Icon(Icons.more_vert),
          ],
        ),
        SizedBox(height: 20.0),
        Card(
          margin: EdgeInsets.all(0.0),
          child: _CardItens(worship.songs),
        ),
      ]),
    );
  }
}

class _CardItens extends StatelessWidget {
  final List<Song> songs;

  _CardItens(this.songs);

  Widget _buildItem(BuildContext context, int index) {
    final bool hasNext = (index + 1) < this.songs.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, 'pdf'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Text(songs[index].title),
              ),
              Divider(
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
                color: hasNext ? Colors.grey[600] : Colors.transparent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: _buildItem,
      itemCount: songs.length,
    );
  }
}
