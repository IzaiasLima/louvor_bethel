import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/pages/login_page.dart';
import 'package:louvor_bethel/pages/home_page.dart';
import 'package:louvor_bethel/pages/pdf_view_page.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// FutureBuilder(
// future: Provider.of<AuthService>(context).getUser(),
// builder: (context, AsyncSnapshot snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// return snapshot.hasData ? HomePage() : LoginPage();
// } else {
// return Container(color: Colors.white);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Louvor Bethel',
      theme: _theme,
      home: StreamBuilder(
        stream: Provider.of<AuthProvider>(context, listen: false).user,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data == Status.Waitting) {
            return LoginPage();
          } else {
            return snapshot.data == Status.Authenticated
                ? HomePage()
                : LoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/pdf': (context) => PdfViewPage(),
        '/sair': (context) => LoginPage(),
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.blueGrey,
      inactiveTrackColor: Colors.brown,
      trackShape: RoundedRectSliderTrackShape(),
      thumbColor: Colors.blueGrey,
      trackHeight: 4.0,
    ),
  );
}
