import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
// import 'package:louvor_bethel/pages/animation.dart';
import 'package:louvor_bethel/pages/home_page.dart';
import 'package:louvor_bethel/pages/login_page.dart';
import 'package:louvor_bethel/pages/pdf_flutter_page.dart';
import 'package:louvor_bethel/pages/scroll_page.dart';
// import 'package:louvor_bethel/pages/full_view_page.dart';
// import 'package:louvor_bethel/pages/lp_page.dart';
// import 'package:louvor_bethel/pages/pdf_render_page.dart';
// import 'package:louvor_bethel/pages/pdf_jk_page.dart';
// import 'package:louvor_bethel/pages/pdf_view2.dart';
// import 'package:louvor_bethel/pages/render_page.dart';
// import 'package:louvor_bethel/pages/simple_pdf_page.dart';
// import 'package:louvor_bethel/pages/view_plugin_page.dart';

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
      theme: _theme,
      home: HomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/animation': (context) => ScrollPage(),
        '/login': (context) => LoginPage(),
        '/pdf': (context) => PdfFlutterPage(),
        '/sair': (context) => LoginPage(),
        // '/full': (context) => FullViewPage(),
        // '/render': (context) => RenderPage(),
        // '/jk': (context) => JKHomePage(),
        // '/plugin': (context) => ViewPluginPage(),
        // '/simple': (context) => SimplePdfPage(),
        // '/lp': (context) => LpPage(),
        // '/pdfview2': (context) => PDFView2(),
      },
    );
  }

  final _theme = ThemeData(
    primaryColor: const Color.fromRGBO(98, 95, 90, 1),
    accentColor: Colors.black26,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: const Color.fromRGBO(243, 240, 240, 1),
    backgroundColor: const Color.fromRGBO(98, 94, 90, 0.8),
    fontFamily: 'Nunito',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 14.0),
      bodyText2: TextStyle(fontSize: 14.0),
    ),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: const Color.fromRGBO(98, 95, 90, 1),
        onPrimary: Colors.white,
        onSurface: Colors.grey,
      ),
    ),
  );
}
