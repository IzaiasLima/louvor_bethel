import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/ui/pdf_view_page.dart';
import 'package:louvor_bethel/ui/home_page.dart';
import 'package:louvor_bethel/ui/landing_page.dart';
import 'package:louvor_bethel/ui/user_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'landing':
        return MaterialPageRoute(builder: (_) => LandingPage());
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
