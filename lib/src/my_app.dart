import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/repositories/worship_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';
import 'package:louvor_bethel/src/routes/routers.dart';
import 'package:louvor_bethel/src/ui/lyric_details_page.dart';
import 'package:louvor_bethel/src/ui/lyric_edit_page.dart';
import 'package:louvor_bethel/src/ui/pdf_view_page.dart';
import 'package:louvor_bethel/src/ui/video_play.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserManager()),
        // ChangeNotifierProvider(create: (_) => LyricRepository(), lazy: false),
        ChangeNotifierProxyProvider<UserManager, LyricRepository>(
          create: (_) => LyricRepository(),
          update: (_, uRepo, lRepo) => lRepo..update(uRepo),
          lazy: false,
        ),
        ChangeNotifierProvider(create: (_) => WorshipRepository()),
        // ChangeNotifierProxyProvider<LyricRepository, WorshipRepository>(
        //   create: (_) => WorshipRepository(),
        //   update: (_, repo, wRepo) => wRepo..update(repo),
        //   lazy: false,
        // ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: Constants.title,
        theme: _theme,
        initialRoute: 'landing',
        routes: {
          LyricDetailsPage.routeName: (context) => LyricDetailsPage(),
          LyricEditPage.routeName: (context) => LyricEditPage(),
          PdfViewPage.routeName: (context) => PdfViewPage(),
          VideoPlay.routeName: (context) => VideoPlay(),
        },
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }

  final _theme = ThemeData(
    primaryColor: const Color.fromRGBO(98, 95, 90, 1),
    secondaryHeaderColor: Colors.black26,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: const Color.fromRGBO(243, 240, 240, 1),
    backgroundColor: const Color.fromRGBO(98, 94, 90, 0.8),
    fontFamily: 'Nunito',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 11.0, color: Colors.grey),
      headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 13.0),
      bodyText2: TextStyle(fontSize: 14.0),
      subtitle2: TextStyle(fontSize: 11.5),
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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        primary: const Color.fromRGBO(98, 95, 90, 1),
        onPrimary: Colors.white,
        onSurface: Colors.grey,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
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