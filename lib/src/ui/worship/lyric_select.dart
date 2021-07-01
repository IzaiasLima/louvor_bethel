import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

class LyricSelect extends StatefulWidget {
  @override
  _LyricSelectState createState() => _LyricSelectState();
}

class _LyricSelectState extends State<LyricSelect> {
  @override
  Widget build(BuildContext context) {
    // List<LyricModel> lyrics = context.read<LyricRepository>().filteredLyrics;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Consumer<LyricRepository>(
          builder: (_, repo, __) =>
              Text(repo.search.isNotEmpty ? '${repo.search}' : ''),
        ),
        actions: [
          searchLyrics(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Consumer<LyricRepository>(
            builder: (_, repo, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selecione as músicas'),
                  Divider(color: Colors.black),
                  SizedBox(height: 10.0),
                  Column(
                    children: repo.filteredLyrics
                        .map((l) => CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(l.title),
                            value: l.selected,
                            onChanged: (val) {
                              setState(() => l.selected = val);
                            }))
                        .toList(),
                  ),
                  Divider(color: Colors.black),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    child: Text('INCLUIR'),
                    onPressed: () {
                      List<Lyric> sel = repo.filteredLyrics
                          .where((l) => l.selected == true)
                          .toList();
                      Navigator.pop(context, sel);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
