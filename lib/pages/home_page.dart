import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:louvor_bethel/common/string_helper.dart';

import 'package:louvor_bethel/models/worship.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Worship meetings = Worship.adoracao();
    final DateFormat dia = DateFormat().addPattern("EEEE H'h'm");
    final capitalize = StringHelper.capitalize;

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [
          Icon(Icons.home),
        ],
      ),
      body: Column(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Semana 21/03 a 26/03'),
            Divider(color: Colors.black, height: 2),
          ]),
          Row(
            children: [
              Text(capitalize(dia.format(meetings.dateTime))),
              SizedBox(width: 8),
              Text(meetings.description),
            ],
          ),
          Card(child: _CardItens(meetings.lyrics)),
        ],
      ),
    );
  }
}

// Container(
//   height: 1000,
//   child: Padding(
//     padding: const EdgeInsets.all(20.0),

class _CardItens extends StatelessWidget {
  final lyrics;

  _CardItens(this.lyrics);

  Widget _buildItem(BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            lyrics[index].title,
            style: TextStyle(color: Colors.deepPurple),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: _buildItem,
      itemCount: lyrics.length,
    );
  }
}
