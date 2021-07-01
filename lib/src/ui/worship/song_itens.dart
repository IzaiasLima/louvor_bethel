import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_details_page.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/lyric/media/pdf_view_page.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

class SongItens extends StatelessWidget {
  final Worship worship;

  SongItens(this.worship);

  @override
  Widget build(BuildContext context) {
    return worship.songs != null
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: worship.songs.length,
            itemBuilder: (context, index) =>
                _buildItem(context, worship.songs, index),
          )
        : Container(
            padding: EdgeInsets.all(16.0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Text('Sem eventos na semana selecionada.'),
          );
  }

  Widget _buildItem(BuildContext context, songs, int index) {
    String songId = songs[index]['id'];
    final bool hasNext = (index + 1) < songs.length;
    final Lyric lyric = context.read<LyricRepository>().lyricById(songId);
    final args = RouteObjectArgs(lyric);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onLongPress: () => lyric.id != null
              ? Navigator.pushNamed(context, LyricDetailsPage.routeName,
                  arguments: args)
              : errorSnackBar(context, 'Música inexiste na base de dados.'),
          onTap: () async {
            (lyric == null || !lyric.hasPdf)
                ? errorSnackBar(context, 'PDF não incluído para esta música.')
                : Navigator.pushNamed(context, PdfViewPage.routeName,
                    arguments: args);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        songs[index]['title'],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                indent: 16.0,
                endIndent: 16.0,
                color: hasNext ? Colors.grey[500] : Colors.transparent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
