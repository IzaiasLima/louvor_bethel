import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louvor_bethel/src/models/user.dart';

Widget circleAvatar(UserModel user, double radius) {
  try {
    if (user.photo == null)
      user.photo = Image.asset('assets/images/user_avatar.png');
  } catch (_) {}

  return CircleAvatar(
    radius: radius,
    backgroundImage: user.photo.image,
  );
}

SnackBar snackBar(String msg, {color}) {
  return SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 5),
    backgroundColor: color ?? Colors.red,
  );
}
