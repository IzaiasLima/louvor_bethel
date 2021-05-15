import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                              context, Icon(Icons.home), 'Início', '/home'),
                          _listtile(
                              context, Icon(Icons.security), 'Login', '/login'),
                          _listtile(context, Icon(Icons.security), 'Animação',
                              '/animation'),
                          _listtile(context, Icon(Icons.security),
                              'PDF Flutter', '/pdf'),
                          _listtile(context, Icon(Icons.exit_to_app), 'Sair',
                              '/sair'),
                          // _listtile(context, Icon(Icons.security), 'Lp PDF', '/lp'),
                          // _listtile(context, Icon(Icons.picture_as_pdf), 'PDF JK', '/jk'),
                          // _listtile(context, Icon(Icons.picture_as_pdf), 'Simple PDF',
                          // '/simple'),
                          // _listtile(context, Icon(Icons.picture_as_pdf),
                          // 'Full PDF', '/full'),
                          // _listtile(context, Icon(Icons.picture_as_pdf),
                          // 'PDF plugin', '/plugin'),
                          // _listtile(context, Icon(Icons.picture_as_pdf), 'PDF Render',
                          // '/render'),
                          // _listtile(context, Icon(Icons.picture_as_pdf), 'PDF View2',
                          // '/pdfview2'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
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
}
