import 'package:flutter/material.dart';

class AppTheme {
  // final double fonteSize = 12.0;

  //final MaterialColor swatchColor = Colors.indigo;

  // final Color backColor = Color.fromARGB(255, 255, 250, 250);
  final textStyleBold = theme().textTheme.subtitle1;

  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final r = color.red, g = color.green, b = color.blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static ThemeData theme() {
    final double fonteSize = 11.0;
    final MaterialColor themeColor =
        _createMaterialColor(Color.fromRGBO(48, 49, 60, 1));

    return ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(242, 240, 240, 1),
      accentColor: Colors.white60,
      backgroundColor: const Color.fromRGBO(48, 49, 60, 0.8),
      buttonTheme: ButtonThemeData(
        buttonColor: themeColor.shade500,
        disabledColor: themeColor.withRed(200),
        splashColor: themeColor.shade50,
        textTheme: ButtonTextTheme.primary,
      ),
      bottomAppBarColor: const Color.fromRGBO(57, 58, 71, 1),
      hintColor: themeColor.shade500,
      primarySwatch: _createMaterialColor(const Color.fromRGBO(48, 49, 60, 1)),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.black,
          fontSize: fonteSize,
          height: 1.3,
        ),
        bodyText2: TextStyle(
          color: Colors.black,
          fontSize: fonteSize + 2,
          height: 1.2,
        ),
        headline1: TextStyle(
          color: Colors.white,
          fontSize: fonteSize + 2,
          letterSpacing: 3,
        ),
        headline2: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: fonteSize,
        ),
      ),
    );
  }
}
