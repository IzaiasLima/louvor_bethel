import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/landing_page.dart';
import 'package:louvor_bethel/src/ui/login_page.dart';
import 'package:louvor_bethel/src/ui/lyric_edit_page.dart';
import 'package:louvor_bethel/src/ui/lyric_list_page.dart';
import 'package:louvor_bethel/src/ui/lyric_page.dart';
import 'package:louvor_bethel/src/ui/pdf_view_page.dart';
import 'package:louvor_bethel/src/ui/sigup_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'landing':
        return MaterialPageRoute(builder: (_) => LandingPage());
      case 'home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'lyric_list':
        return MaterialPageRoute(builder: (_) => LyricListPage());
      case 'lyric':
        return MaterialPageRoute(builder: (_) => LyricPage());
      case 'lyric_edit':
        return MaterialPageRoute(builder: (_) => LyricEditPage());
      case 'pdf':
        return MaterialPageRoute(builder: (_) => PdfViewPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
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
