import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:louvor_bethel/models/worship.dart';

class RenderPage extends StatefulWidget {
  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  final Worship adoracao = Worship.adoracao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [_circleAvatar(adoracao.userAvatar)],
        titleSpacing: 0.0,
        title: Text('LOUVOR BETHEL'),
      ),
      body: Container(
        child: Text('Render PDF'),
      ),
    );
  }

  Widget _circleAvatar(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CircleAvatar(
        radius: 22.0,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
