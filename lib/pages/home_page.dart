import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';

import 'package:louvor_bethel/common/string_helper.dart';
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
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [_circleAvatar(adoracao.userAvatar)],
        titleSpacing: 0.0,
        title: Text('LOUVOR BETHEL'),
      ),
      body: SingleChildScrollView(
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
            _Card(adoracao),
            _Card(oferta),
          ],
        ),
      ),
    );
  }

  Widget _circleAvatar(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CircleAvatar(
        radius: 22.0,
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                SizedBox(width: 8.0),
                Text(
                  capitalize(dia.format(worship.dateTime)),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  //style: Theme.of(context).textTheme.headline1,
                  //style: AppTheme.theme().textTheme.headline2,
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
          onTap: () => Navigator.popAndPushNamed(context, '/render'),
          child: Row(
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
                color: hasNext ? Colors.grey[400] : Colors.transparent,
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
