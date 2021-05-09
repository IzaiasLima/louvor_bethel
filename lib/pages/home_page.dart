import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [
          Icon(Icons.home),
        ],
      ),
      body: Column(children: [
        Column(children: [
          Container(
            child: Text('Semana 21/03 a 26/03'),
          ),
          Divider(color: Colors.black),
        ]),
        Row(
          children: [
            Text('Domingo 18h30'),
            SizedBox(width: 8),
            Text('Celebração'),
          ],
        ),
        Card(
          child: Column(children: [
            Text('Ao único que é digno'),
            Text('Grande é o Senhor'),
            Text('Tua mão forte'),
            Text('Que se abram os céus'),
            Text('Ele é exaltado'),
            Text('Yeshua'),
          ]),
        ),
      ]),
    );
  }
}
