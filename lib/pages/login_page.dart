import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TextEditingController _controller = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                TextFormField(
                  // controller: _controller,
                  autocorrect: false,
                  obscureText: true,
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
                      child: Text(
                        'ENTRAR',
                        // style: AppTheme.theme().textTheme.headline1,
                      ),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
