import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/landing_page.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_add_page.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_list_page.dart';
import 'package:louvor_bethel/src/ui/lyric/lyric_details_page.dart';
import 'package:louvor_bethel/src/ui/schedule/performer_select.dart';
import 'package:louvor_bethel/src/ui/schedule/schedule.dart';
import 'package:louvor_bethel/src/ui/user/login_page.dart';
import 'package:louvor_bethel/src/ui/user/sigup_page.dart';
import 'package:louvor_bethel/src/ui/user/user_edit_page.dart';
import 'package:louvor_bethel/src/ui/worship/lyric_select.dart';
import 'package:louvor_bethel/src/ui/worship/worship_add_page.dart';

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
      case 'schedule':
        return MaterialPageRoute(builder: (_) => SchedulePage());
      case 'performer_select':
        return MaterialPageRoute(builder: (_) => PerformerSelect());
      case 'worship_add':
        return MaterialPageRoute(builder: (_) => WorshipAddPage());
      case 'lyric_select':
        return MaterialPageRoute(builder: (_) => LyricSelect());
      case 'user':
        return MaterialPageRoute(builder: (_) => UserEditPage());
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
