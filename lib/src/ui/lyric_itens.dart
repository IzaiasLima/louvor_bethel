import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/route_args.dart';

class LyricItens extends StatelessWidget {
  final List lyrics;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            final args = RouteArgs(strParam: lyrics[index].id);
            Navigator.pushNamed(context, page, arguments: args);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Text(
                  lyrics[index].title,
                  style: Theme.of(context).textTheme.bodyText2,
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
