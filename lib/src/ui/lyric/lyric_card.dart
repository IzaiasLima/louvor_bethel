import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/worship/song_itens.dart';

class LyricCard extends StatelessWidget {
  final Worship worship;
  final DateFormat fmt = DateFormat().addPattern("EEEE, dd/MM H'h'mm");

  LyricCard(this.worship);

  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserManager>().user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            color: Colors.white.withAlpha(180),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      circleAvatar(worship.user, 18),
                      SizedBox(width: 4.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringHelper.capitalize(
                                fmt.format(worship.dateTime)),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(worship.description,
                              style: TextStyle(height: 0.95)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (user.isAdmin) _popUpMenu(context, worship.id),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Card(margin: EdgeInsets.zero, child: SongItens(worship)),
          SizedBox(height: 22.0),
        ],
      ),
    );
  }

  Widget _popUpMenu(BuildContext context, String worshipId) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.all(10),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 2,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.delete_outlined),
                SizedBox(width: 16.0),
                Text('Fazer escala'),
              ],
            ),
            onTap: () async {
              Navigator.pop(context);
              if (await confirm(
                context,
                content: Text('Fazer a escala dos músicos para este evento?'),
                textOK: Text('SIM'),
                textCancel: Text('NÃO'),
              )) {
                customSnackBar(context, 'Exclusão efetuada com sucesso.');
                return;
              }
              return;
            },
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
                await context.read<WorshipRepository>().delete(worshipId,
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
