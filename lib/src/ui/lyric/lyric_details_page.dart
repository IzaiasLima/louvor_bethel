import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/ui/lyric/media/pdf_view_page.dart';

class LyricDetailsPage extends StatelessWidget {
  static const routeName = 'lyric_details';

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context).settings.arguments as RouteArgs;
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    final lyric = args.objParam as LyricModel;
    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Consumer<LyricRepository>(builder: (context, repo, child) {
          if (repo.lyrics.length > 0) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                  child: _lyricDetail(context, lyric),
                ),
              ],
            );
          } else {
            return null;
          }
        }),
      ),
    );
  }

  Widget _lyricDetail(BuildContext context, LyricModel lyric) {
    final theme = Theme.of(context).textTheme;
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
                    style: theme.headline6,
                  ),
                  Text(
                    StringHelper.listToString(lyric.style),
                    style: theme.subtitle2,
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
                    style: theme.headline5,
                  ),
                  SizedBox(height: 22.0),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey, thickness: 2.0),
        Text(
          'Primeiro verso da estrofe',
          style: theme.headline2,
        ),
        Text(lyric.stanza),
        Divider(color: Constants.grayColor, thickness: 1.0),
        // SizedBox(height: 20.0),
        Text(
          'Primeiro verso do coro',
          style: theme.headline2,
        ),
        Text(lyric.chorus),
        Divider(color: Constants.grayColor, thickness: 1.0),
        SizedBox(height: 15.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => lyric.pdfUrl == null || lyric.pdfUrl.isEmpty
                  ? {}
                  : Navigator.pushNamed(context, PdfViewPage.routeName,
                      arguments: RouteObjectArgs(lyric)),
              child: Text(lyric.pdfUrl == null || lyric.pdfUrl.isEmpty
                  ? 'SEM CIFRA'
                  : ' CIFRA '),
            ),
            SizedBox(width: 15.0),
            ElevatedButton(
              onPressed: () => lyric.videoUrl == null || lyric.videoUrl.isEmpty
                  ? {}
                  : Navigator.pushNamed(context, 'video',
                      arguments: RouteArgs(lyric.videoUrl)),
              child: Text(lyric.videoUrl == null || lyric.videoUrl.isEmpty
                  ? 'SEM LINK'
                  : ' LINK '),
              style: ElevatedButton.styleFrom(
                primary: Constants.redColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
