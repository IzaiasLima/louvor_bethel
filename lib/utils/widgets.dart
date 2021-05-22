import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:louvor_bethel/models/auth_model.dart';

Widget circleAvatar(String urlphoto) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: CircleAvatar(
      radius: 22.0,
      backgroundImage: NetworkImage(urlphoto),
    ),
  );
}

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget expiredSessionCard(AuthModel model) {
  return Padding(
    padding: EdgeInsets.all(50.0),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 10.0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
              child: Column(
                children: [
                  Text(
                    'Sua conexão foi encerrada. Favor se logar novamente.',
                  ),
                  TextButton(
                    onPressed: () => model.logOut(),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'OK',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    ),
  );
}
