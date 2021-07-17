import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_details_page.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_edit_page.dart';

class LyricItens extends StatefulWidget {
  @override
  _LyricItensState createState() => _LyricItensState();
}

class _LyricItensState extends State<LyricItens> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LyricRepository>(
      builder: (_, repo, __) => (repo.lyrics != null && repo.lyrics.length > 0)
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: repo.filteredLyrics.length,
              itemBuilder: (context, index) =>
                  _buildItem(context, repo.filteredLyrics, index),
            )
          : Container(height: 0.0),
    );
  }

  Widget _buildItem(BuildContext context, lyrics, int index) {
    final bool hasNext = (index + 1) < lyrics.length;
    UserModel user = context.read<UserManager>().user;
    Lyric lyric = lyrics[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              LyricDetailsPage.routeName,
              arguments: RouteObjectArgs(lyric),
            );
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
                    if (user.isManager)
                      _popUpMenu(context, lyric)
                    else
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(height: 16.0),
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

  Widget _popUpMenu(BuildContext context, Lyric lyric) {
    return PopupMenuButton<int>(
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
                Icon(Icons.delete_outlined, color: Colors.red),
                SizedBox(width: 16.0),
                Text('Excluir', style: Constants.txtDanger),
              ],
            ),
            onTap: () async {
              if (await confirm(
                context,
                content:
                    Text("Deseja mesmo excluir a música '${lyric.title}' ?"),
                textOK: Text('SIM', style: Constants.txtDanger),
                textCancel: Text('NÃO', style: Constants.txtGood),
              )) {
                Navigator.pop(context);
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
  }
}
