import 'package:flutter/material.dart';
import 'package:louvor_bethel/models/auth_model.dart';
import 'package:louvor_bethel/ui/base_view.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      builder: (context, model, __) => SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Drawer(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
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
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'by Izaias Moreira Lima',
                        style: TextStyle(
                          fontSize: 10.0,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'coder@izaias.dev',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          _listtile(
                              context, Icon(Icons.home), 'Início', 'landing'),
                          _listtile(
                              context, Icon(Icons.play_arrow), 'PDF', 'pdf'),
                          _logout(
                              context, Icon(Icons.exit_to_app), 'Sair', model),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listtile(context, Icon icon, String text, String page) {
    return InkWell(
      onTap: () => Navigator.of(context).popAndPushNamed(page),
      child: ListTile(
        horizontalTitleGap: 0.0,
        dense: true,
        leading: icon,
        title: Text(text),
      ),
    );
  }

  Widget _logout(context, Icon icon, String text, AuthModel model) {
    return InkWell(
      onTap: () => model.logOut(),
      child: ListTile(
        horizontalTitleGap: 0.0,
        dense: true,
        leading: icon,
        title: Text(text),
      ),
    );
  }
}
