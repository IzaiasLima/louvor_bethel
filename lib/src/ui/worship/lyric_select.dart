import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';

class LyricSelect extends StatefulWidget {
  @override
  _LyricSelectState createState() => _LyricSelectState();
}

class _LyricSelectState extends State<LyricSelect> {
  @override
  Widget build(BuildContext context) {
    List<LyricModel> lyrics = context.read<LyricRepository>().lyrics;

    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: AppBar(automaticallyImplyLeading: true),
      // drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selecione as músicas'),
              Divider(color: Colors.black),
              SizedBox(height: 10.0),
              Column(
                children: lyrics
                    .map(
                      (l) => CheckboxListTile(
                        title: Text(l.title),
                        contentPadding: EdgeInsets.zero,
                        dense: false,
                        selectedTileColor: Constants.grayColor,
                        value: l.selected,
                        onChanged: (val) {
                          setState(() {
                            l.selected = val;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              Divider(color: Colors.black),
              SizedBox(height: 10.0),
              ElevatedButton(
                child: Text('INCLUIR'),
                onPressed: () {
                  List<LyricModel> sel =
                      lyrics.where((l) => l.selected == true).toList();
                  Navigator.pop(context, sel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
