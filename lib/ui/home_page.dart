import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/utils/constants.dart';
import 'package:louvor_bethel/utils/string_helper.dart';
import 'package:louvor_bethel/ui/drawer.dart';
import 'package:louvor_bethel/ui/base_view.dart';
import 'package:louvor_bethel/models/auth_model.dart';
import 'package:louvor_bethel/models/worship.dart';
import 'package:louvor_bethel/utils/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Worship adoracao = Worship.adoracao();
    final Worship oferta = Worship.oferta();

    return BaseView<AuthModel>(
      builder: (context, model, __) => Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          actions: [circleAvatar(adoracao.userAvatar)],
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
                          Text('Nome: ${model.user?.name}'),
                          Text('Email: ${model.user?.email}'),
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
