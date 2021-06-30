import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/schedule.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/routes/route_args.dart';
import 'package:louvor_bethel/src/ui/schedule/schedule_page.dart';
import 'package:louvor_bethel/src/ui/schedule/schedule_details_page.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

import 'package:louvor_bethel/src/commons/string_helper.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:louvor_bethel/src/ui/worship/song_itens.dart';

class LyricCard extends StatelessWidget {
  final DateFormat fmt = DateFormat().addPattern("EEEE, dd/MM H'h'mm");
  final Worship worship;
  // Schedule schedule;

  LyricCard(this.worship);

  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserManager>().user;
    Schedule schedule;

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
                (user.isAdmin)
                    ? _popUpAdminMenu(context, worship)
                    : _popUpMenu(context, worship),
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

  Widget _popUpMenu(BuildContext context, Worship worship) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.all(10),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 1,
          enabled: worship.schedule != null,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.list_outlined),
                SizedBox(width: 16.0),
                Text('Consultar escala'),
              ],
            ),
            onTap: () async {
              Navigator.pop(context);
              if (worship.schedule != null) {
                Navigator.pushNamed(context, ScheduleDetailsPage.routeName,
                    arguments: RouteObjectArgs(worship));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _popUpAdminMenu(BuildContext context, Worship worship) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.all(10),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 1,
          enabled: worship.schedule != null,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.list_outlined),
                SizedBox(width: 16.0),
                Text('Consultar escala'),
              ],
            ),
            onTap: () async {
              Navigator.pop(context);
              if (worship.schedule != null) {
                Navigator.pushNamed(context, ScheduleDetailsPage.routeName,
                    arguments: RouteObjectArgs(worship));
              }
            },
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 16.0),
                Text('Fazer escala'),
              ],
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.pushNamed(context, SchedulePage.routeName,
                  arguments: RouteObjectArgs(worship));
            },
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.copy_outlined),
                SizedBox(width: 16.0),
                Text('Copiar escala'),
              ],
            ),
            onTap: () async {
              Clipboard.setData(
                  ClipboardData(text: worship.schedule.toString()));
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: InkWell(
            child: Row(
              children: [
                Icon(Icons.paste_outlined),
                SizedBox(width: 16.0),
                Text('Colar escala'),
              ],
            ),
            onTap: () async {
              Navigator.popAndPushNamed(context, SchedulePage.routeName,
                  arguments: RouteObjectArgs(worship));
            },
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: InkWell(
            child: Row(
              children: [
                Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                ),
                SizedBox(width: 16.0),
                Text('Excluir evento', style: TextStyle(color: Colors.red)),
              ],
            ),
            onTap: () async {
              Navigator.pop(context);
              if (await confirm(
                context,
                content: Text('Deseja mesmo excluir este evento?'),
                textOK: Text('SIM'),
                textCancel: Text('NÃO'),
              )) {
                await context.read<WorshipRepository>().delete(worship.id,
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
