import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:louvor_bethel/common/string_helper.dart';
import 'package:louvor_bethel/common/theme.dart';
import 'package:louvor_bethel/models/worship.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Worship adoracao = Worship.adoracao();
    final Worship oferta = Worship.oferta();

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [_circleAvatar(adoracao.userAvatar)],
        title: Text(
          'LOUVOR BETHEL',
          style: AppTheme.theme().textTheme.headline1,
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 0),
              child: Column(
                children: [
                  Text('Semana 21/03 a 26/03'),
                  Divider(color: Colors.black),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            _Card(adoracao),
            _Card(oferta),
          ],
        ),
      ),
    );
  }

  Widget _circleAvatar(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(url),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(worship.userAvatar),
                ),
                SizedBox(width: 8),
                Text(
                  capitalize(dia.format(worship.dateTime)),
                  style: AppTheme.theme().textTheme.headline2,
                ),
                SizedBox(width: 8),
                Text(worship.description),
              ],
            ),
            Icon(Icons.more_vert),
          ],
        ),
        SizedBox(height: 20),
        Card(
          margin: EdgeInsets.all(0),
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(songs[index].title),
        ),
        Divider(
          height: 0,
          indent: 16,
          endIndent: 16,
          color: hasNext ? Colors.grey : Colors.transparent,
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
