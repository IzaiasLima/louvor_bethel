import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/lyric_item.dart';

class LyricCard extends StatelessWidget {
  final Worship worship;
  final capitalize = StringHelper.capitalize;
  final DateFormat dia = DateFormat().addPattern("EEEE H'h'm");

  LyricCard(this.worship);

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
          child: LyricItem(worship.lyrics),
        ),
      ]),
    );
  }
}
