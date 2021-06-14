import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/lyric_details_page.dart';
import 'package:louvor_bethel/src/ui/lyric_edit_page.dart';
import 'package:provider/provider.dart';

class LyricItens extends StatelessWidget {
  // final List<LyricModel> lyrics;
  final String page;

  LyricItens({this.page});

  @override
  Widget build(BuildContext context) {
    return Consumer<LyricRepository>(
      builder: (_, repo, __) => (repo.lyrics != null && repo.lyrics.length > 0)
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: repo.lyrics.length,
              itemBuilder: (context, index) =>
                  _buildItem(context, repo.lyrics, index),
            )
          : Container(
              padding: EdgeInsets.all(16.0),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Text('Não havia dados para exibir.'),
            ),
    );
  }

  Widget _buildItem(BuildContext context, lyrics, int index) {
    final bool hasNext = (index + 1) < lyrics.length;
    LyricModel lyric = lyrics[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            final args = RouteObjectArgs(lyric);
            page == 'pdf' && (lyric.pdfUrl == null || lyric.pdfUrl.isEmpty)
                ? errorSnackBar(context, 'PDF não incluído para esta música.')
                : Navigator.pushNamed(context, page, arguments: args);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lyrics[index].title,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    page == LyricDetailsPage.routeName
                        ? _popUpMenu(context, lyric)
                        : SizedBox(height: 45.0),
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

  Widget _popUpMenu(BuildContext context, LyricModel lyric) =>
      PopupMenuButton<int>(
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 1,
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 16.0),
                  Text('Atualizar'),
                ],
              ),
              onTap: () => Navigator.popAndPushNamed(
                context,
                LyricEditPage.routeName,
                arguments: RouteObjectArgs(lyric),
              ),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.delete_outlined),
                  SizedBox(width: 16.0),
                  Text('Excluir'),
                ],
              ),
              onTap: () async {
                Navigator.pop(context);
                if (await confirm(
                  context,
                  content: Text('Deseja mesmo excluir?'),
                  textOK: Text('SIM'),
                  textCancel: Text('NÃO'),
                )) {
                  await context.read<LyricRepository>().delete(lyric.id,
                      onSucess: () => customSnackBar(
                          context, 'Exclusão efetuada com sucesso.'),
                      onError: (err) =>
                          errorSnackBar(context, 'Erro na exclusão: $err'));
                  return;
                }
                return;
              },
            ),
          ),
        ],
      );

  PopupMenuItem<int> popUpMenuItem(context, int pos, Icon icon, String item,
      {String page, args}) {
    return PopupMenuItem(
      value: pos,
      child: ListTile(
        leading: icon,
        title: Text(item),
        onTap: () {
          Navigator.popAndPushNamed(context, page, arguments: args);
        },
      ),
    );
  }
}
