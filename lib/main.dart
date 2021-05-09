import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/theme.dart';
import 'package:louvor_bethel/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Louvor Bethel',
      theme: appTheme,
      home: HomePage(),
    );
  }
}
