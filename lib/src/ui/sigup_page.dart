import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  UserModel user = UserModel();

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
                      _nameTextField(),
                      _emailTextField(),
                      _passwordFormField(),
                      _confirmPassFormField(),
                      Padding(
                        padding: const EdgeInsets.all(26.0),
                        child: userManager.viewState == ViewState.Busy
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text('CADASTRAR'),
                                onPressed: () {
                                  if (!formKey.currentState.validate()) {
                                    return;
                                  }
                                  formKey.currentState.save();
                                  if (user.password != user.confirmPass) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        snackBar(Constants.neededEqPwd));
                                    return;
                                  }

                                  userManager.signUp(
                                    newUser: user,
                                    onSucess: () => Navigator.of(context)
                                        .popAndPushNamed('home'),
                                    onError: (e) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar(e)),
                                  );
                                },
                              ),
                      ),
                      _loginTextButtom(),
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

  Widget _nameTextField() {
    return TextFormField(
      autofillHints: [AutofillHints.name],
      autocorrect: true,
      validator: (value) => validName(value) ? null : Constants.neededUserName,
      decoration: InputDecoration(
        labelText: 'Nome do usuário',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (name) => user.name = name,
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      autocorrect: false,
      validator: (value) => validEmail(value) ? null : Constants.validEmail,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (email) => user.email = email,
    );
  }

  Widget _passwordFormField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      validator: (value) => validPassword(value) ? null : Constants.neededPwd,
      decoration: InputDecoration(
        labelText: 'Senha',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (pass) => user.password = pass,
    );
  }

  Widget _confirmPassFormField() {
    return TextFormField(
      // controller: confirmPassdController,
      autocorrect: false,
      obscureText: true,
      validator: (value) => validPassword(value) ? null : Constants.neededPwd,
      decoration: InputDecoration(
        labelText: 'Cofirme a senha',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      onSaved: (pass) => user.confirmPass = pass,
    );
  }

  Widget _loginTextButtom() {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () => Navigator.of(context).popAndPushNamed('login'),
        child: Text('Já sou cadastrado.'),
      ),
    );
  }
}
