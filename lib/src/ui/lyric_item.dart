import 'package:flutter/material.dart';

class LyricItem extends StatelessWidget {
  final List lyrics;
  final String page;

  LyricItem(this.lyrics, {this.page = 'pdf'});

  Widget _buildItem(BuildContext context, int index) {
    final bool hasNext = (index + 1) < this.lyrics.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Text(lyrics[index].title),
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
      itemCount: lyrics.length,
    );
  }
}
