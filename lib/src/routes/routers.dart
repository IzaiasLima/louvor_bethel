import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/landing_page.dart';
import 'package:louvor_bethel/src/ui/lyric_page.dart';
import 'package:louvor_bethel/src/ui/pdf_view_page.dart';
import 'package:louvor_bethel/src/ui/user_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'landing':
        return MaterialPageRoute(builder: (_) => LandingPage());
      case 'lyric':
        return MaterialPageRoute(builder: (_) => LyricPage());
      case 'pdf':
        return MaterialPageRoute(builder: (_) => PdfViewPage());
      case 'user':
        return MaterialPageRoute(builder: (_) => UserPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text('Página "${settings.name}" não existe.'),
          ));
        });
    }
  }
}
