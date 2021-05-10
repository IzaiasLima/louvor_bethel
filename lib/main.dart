import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:louvor_bethel/common/theme.dart';
import 'package:louvor_bethel/pages/home_page.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting();
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
