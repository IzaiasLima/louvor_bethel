import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserModel {
  String id;
  String email;
  String name;
  String photoUrl;
  ImageProvider<Object> photo;

  UserModel({this.id, this.email, this.name, this.photoUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    photoUrl = json['photoUrl'];
  }

  UserModel.fromAuth(User user) {
    id = user.uid;
    email = user.email;
    name = user.displayName;
    photoUrl = user.photoURL;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
