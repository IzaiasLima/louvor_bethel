import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/models/user_manager.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            _drawerHeader(context),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: ListView(
                  children: [
                    _listtile(context, Icon(Icons.home), 'Início', 'home'),
                    _listtile(context, Icon(Icons.playlist_add),
                        'Cadastrar músicas', 'lyric_add'),
                    _listtile(context, Icon(Icons.queue_music),
                        'Consultar músicas', 'lyric_list'),
                    _listtile(context, Icon(Icons.post_add),
                        'Cadastrar eventos', 'worship_add'),
                    _listtile(context, Icon(Icons.post_add), 'Editar eventos',
                        'lyric_select'),
                    _listtile(
                        context, Icon(Icons.person), 'Editar Perfil', 'user'),
                    _logout(context, Icon(Icons.exit_to_app), 'Sair', 'login'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Consumer<UserManager>(
        builder: (context, value, child) {
          UserModel user = context.read<UserManager>().user;

          return Column(
            children: [
              Container(
                height: 65,
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/bethel.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Text(
                'Louvor Bethel',
                style: TextStyle(height: 1.3, color: Colors.white),
              ),
              Text(
                'by Izaias Moreira Lima',
                style:
                    TextStyle(fontSize: 8.0, height: 1.0, color: Colors.white),
              ),
              Text(
                'coder@izaias.dev',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
              Text(
                user != null ? 'Usuário: ${user.email}' : '',
                style: TextStyle(fontSize: 9.0, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _listtile(context, Icon icon, String text, String page) {
    return InkWell(
      onTap: () {
        Navigator.of(context).popAndPushNamed(page);
      },
      child: ListTile(
        horizontalTitleGap: 0.0,
        dense: true,
        leading: icon,
        title: Text(text),
      ),
    );
  }

  Widget _logout(context, icon, text, page) {
    return Consumer<UserManager>(
      builder: (context, userManager, __) => InkWell(
        onTap: () {
          userManager.logOut();
          Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed('login');
        },
        child: ListTile(
          horizontalTitleGap: 0.0,
          dense: true,
          leading: icon,
          title: Text(text),
        ),
      ),
    );
  }
}
