import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/login_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return SplashScreen(
        seconds: 3,
        imageBackground:
            Image.asset('assets/images/bethel_background.png').image,
        loaderColor: Colors.transparent,
        navigateAfterSeconds: userManager.loggedIn ? HomePage() : LoginPage(),
      );
    });
  }
}
