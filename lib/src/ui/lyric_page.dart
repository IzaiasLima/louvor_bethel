import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:louvor_bethel/src/commons/string_helper.dart';

class LyricPage extends StatelessWidget {
  static const routeName = 'lyric_details';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteArgs;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
              child: FutureProvider<LyricModel>(
                initialData: null,
                create: (context) => LyricRepository().lyricById(args.lyricId),
                builder: (_, child) => Consumer<LyricModel>(
                  builder: (context, lyric, child) => lyric == null
                      ? CircularProgressIndicator()
                      : _lyricDetail(context, lyric),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lyricDetail(BuildContext context, LyricModel lyric) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringHelper.capitalize(lyric.title),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    StringHelper.listToString(lyric.style).toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    StringHelper.capitalize(lyric.tone),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 22.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey, thickness: 2.0),
        // SizedBox(height: 20.0),
        Text(
          'Primeiro verso da estrofe',
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(lyric.stanza),
        Divider(color: Color.fromARGB(255, 200, 200, 200), thickness: 1.0),
        // SizedBox(height: 20.0),
        Text(
          'Primeiro verso do coro',
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(lyric.chorus),
        Divider(color: Color.fromARGB(255, 200, 200, 200), thickness: 1.0),
        SizedBox(height: 15.0),
        Row(
          children: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('pdf'),
                child: Text('CIFRA')),
            SizedBox(width: 15.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('video');
                // https://music.youtube.com/watch?v=RlIgI0YhYZ8
              },
              child: Text('LINK'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 210, 20, 45),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Card(
            elevation: 2,
            child: Image.asset('assets/images/lyric_sample.png'),
          ),
        ),
      ],
    );
  }
}
