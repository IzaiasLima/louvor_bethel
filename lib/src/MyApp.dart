import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/locator.dart';
import 'package:louvor_bethel/src/routes/routers.dart';
import 'package:louvor_bethel/src/shared/constants.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setupLocator();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.title,
      theme: _theme,
      initialRoute: 'landing',
      onGenerateRoute: Routers.generateRoute,
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
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
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
      activeTrackColor: Colors.brown,
      inactiveTrackColor: Colors.brown,
      trackShape: RoundedRectSliderTrackShape(),
      trackHeight: 2.0,
      thumbColor: Colors.blueGrey,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      overlayColor: Colors.yellow.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
    ),
  );
}
