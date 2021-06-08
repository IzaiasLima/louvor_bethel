import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/landing_page.dart';
import 'package:louvor_bethel/src/ui/login_page.dart';
import 'package:louvor_bethel/src/ui/lyric_add_page.dart';
import 'package:louvor_bethel/src/ui/lyric_list_page.dart';
import 'package:louvor_bethel/src/ui/lyric_details_page.dart';
import 'package:louvor_bethel/src/ui/sigup_page.dart';
import 'package:louvor_bethel/src/ui/user_edit_page.dart';

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
        return MaterialPageRoute(builder: (_) => LyricDetailsPage());
      case 'lyric_add':
        return MaterialPageRoute(builder: (_) => LyricAddPage());
      case 'user':
        return MaterialPageRoute(builder: (_) => UserEditPage());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case 'signup':
        return MaterialPageRoute(builder: (_) => SignUpPage());
      // case 'video':
      //   return MaterialPageRoute(builder: (_) => VideoPlay());
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
