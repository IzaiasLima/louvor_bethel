import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:louvor_bethel/src/commons/constants.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/commons/validators.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/ui/commons/components.dart';

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
                      _newPassTextButtom(userManager),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: userManager.viewState == ViewState.Busy
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                child: Text('AUTENTICAR'),
                                onPressed: () {
                                  if (!formKey.currentState.validate()) return;
                                  userManager.signIn(
                                    user: UserModel(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                    onSucess: () => Navigator.of(context)
                                        .pushReplacementNamed('home'),
                                    onError: (e) =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar(e)),
                                  );
                                },
                              ),
                      ),
                      // _switchStateButtom(authStateModel),
                      SizedBox(height: 16),
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

  Widget _newPassTextButtom(UserManager userManager) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text('Esqueci minha senha'),
        onPressed: () {
          if (emailController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackBar("Informe o seu email para recuperar a senha."));
            return;
          }
          userManager.sendPassResetEmail(
            email: emailController.text,
            onSucess: () => _showDialog(),
            onError: (e) =>
                ScaffoldMessenger.of(context).showSnackBar(snackBar(e)),
          );
        },
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('RECUPERAÇÃO DE SENHA'),
          content: SingleChildScrollView(
            child: Text(
                'Foi enviado um link de recuperação de senha para o email informado. Favor verificar as mensagens em sua caixa postal e clicar no link fornecido para criar sua nova senha.'),
          ),
          // insetPadding: EdgeInsets.all(16.0),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('FECHAR', style: Constants.txtGood),
            ),
          ],
        );
      },
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
