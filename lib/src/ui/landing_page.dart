import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:louvor_bethel/src/models/auth_model.dart';
import 'package:louvor_bethel/src/shared/ui/base_view.dart';
import 'package:louvor_bethel/src/ui/home_page.dart';
import 'package:louvor_bethel/src/ui/login_page.dart';

// ignore: must_be_immutable
class LandingPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthModel>(
      builder: (context, authModel, child) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return (snapshot.hasData && snapshot.data != null)
              ? HomePage()
              : LoginPage(
                  emailController: emailController,
                  passwordController: passwordController,
                  authModel: authModel,
                );
        },
      ),
    );
  }
}
