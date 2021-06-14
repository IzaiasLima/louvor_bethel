import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scafoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scafoldKey,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Consumer<UserManager>(
            builder: (_, userManager, __) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _emailTextField(),
                      _passwordFormField(),
                      _newPassTextButtom(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: userManager.viewState == ViewState.Busy
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text('AUTENTICAR'),
                                onPressed: () {
                                  if (!formKey.currentState.validate()) {
                                    return;
                                  }

                                  userManager.signIn(
                                    user: UserModel(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                    onSucess: () => Navigator.of(context)
                                        .popAndPushNamed('home'),
                                    onError: (e) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar(e)),
                                  );
                                },
                              ),
                      ),
                      // _switchStateButtom(authStateModel),
                      SizedBox(
                        height: 40,
                      ),
                      _newUserTextButtom(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      autocorrect: false,
      validator: (value) => validEmail(value) ? null : Constants.validEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _passwordFormField() {
    return TextFormField(
      controller: passwordController,
      autocorrect: false,
      obscureText: true,
      validator: (value) => validPassword(value) ? null : Constants.validPwd,
      decoration: InputDecoration(
        labelText: 'Senha',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _newPassTextButtom() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.of(context).popAndPushNamed('home'),
        child: Text('Esqueci minha senha'),
      ),
    );
  }

  Widget _newUserTextButtom() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => Navigator.of(context).popAndPushNamed('signup'),
        child: Text('Novo por aqui? Cadastre-se!'),
      ),
    );
  }
}
