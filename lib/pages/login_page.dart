import 'package:flutter/material.dart';
import 'package:louvor_bethel/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email;
  TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider login = Provider.of<AuthProvider>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
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
                  ),
                  TextFormField(
                    controller: _pass,
                    autocorrect: false,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Informe a senha.';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => {},
                      child: Text('Esqueci minha senha'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: ElevatedButton(
                        child: Text('ENTRAR'),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            Provider.of<AuthProvider>(context, listen: false)
                                .signInWithEmailAndPassword(
                                    _email.text, _pass.text);
                            print(Provider.of<AuthProvider>(context,
                                    listen: false)
                                .status);
                            if (Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .status ==
                                Status.Authenticated) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              return;
                            }
                          } else {
                            return;
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
