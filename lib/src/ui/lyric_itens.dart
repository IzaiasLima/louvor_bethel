import 'package:flutter/material.dart';

import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

class LyricItens extends StatelessWidget {
  final List<LyricModel> lyrics;
  final String page;

  LyricItens(this.lyrics, {this.page});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lyrics.length,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final bool hasNext = (index + 1) < this.lyrics.length;
    LyricModel lyric = lyrics[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            final args = RouteObjectArgs(lyric);
            lyric.pdfUrl == null || lyric.pdfUrl.isEmpty
                ? onErrorSnackBar(context, 'PDF não incluído para esta música.')
                : Navigator.pushNamed(context, page, arguments: args);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lyrics[index].title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final args = RouteObjectArgs(lyric);
                        Navigator.pushNamed(context, 'lyric_edit',
                            arguments: args);
                      },
                      child: Icon(Icons.edit_outlined),
                    ),
                    Icon(Icons.delete_outline),
                  ],
                ),
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
}
