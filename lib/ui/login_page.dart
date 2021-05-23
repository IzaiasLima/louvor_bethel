import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:louvor_bethel/enum/states.dart';
import 'package:louvor_bethel/ui/base_view.dart';
import 'package:louvor_bethel/models/auth_model.dart';
import 'package:louvor_bethel/models/auth_state_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AuthModel authModel;

  LoginPage({
    @required this.emailController,
    @required this.passwordController,
    @required this.authModel,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BaseView<AuthStateModel>(
      builder: (context, authStateModel, __) {
        // authStateModel.setState(authModel, AuthState.SignIn);

        return Scaffold(
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _emailTextField(),
                      _passwordFormField(),
                      _newPasswordButtom(authModel),
                      authModel.viewState == ViewState.Busy
                          ? CircularProgressIndicator()
                          : _loginActionButton(
                              context,
                              formKey,
                              authStateModel,
                            ),
                      _switchStateButtom(authStateModel),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      autocorrect: false,
      validator: (value) {
        if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value)) {
          return "Informe um email válido.";
        }
        return null;
      },
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
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          return 'A senha dever ter seis caracteres ou mais.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Senha',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget _loginActionButton(context, formKey, AuthStateModel authStateModel) {
    if (authModel.viewState == ViewState.Refused) {
      _showToast('Email ou senha não confere.');
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        child: Text(authStateModel.switchAuthText(authModel)),
        onPressed: () {
          if (formKey.currentState.validate()) {
            authStateModel.switchAuthMethod(
                authModel, emailController, passwordController);
          } else {
            return;
          }
        },
      ),
    );
  }

  Widget _switchStateButtom(AuthStateModel authStateModel) {
    return InkWell(
      onTap: () {
        authStateModel.switchAuthState(authModel);
      },
      child: Text(authStateModel.switchAuthOption(authModel)),
    );
  }

  Widget _newPasswordButtom(AuthModel authModel) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          authModel.passwordReset(emailController.text);
          _showToast('Enviamos um email para você, verifique.');
        },
        child: Text('Esqueci minha senha'),
      ),
    );
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
