import 'package:flutter/material.dart';

class UserModel {
  String id;
  String name;
  String email;
  String urlPhoto;
  Image photo;
  String password;
  String confirmPass;
  bool isAdmin;

  UserModel(
      {this.id = '',
      this.name = '',
      this.email = '',
      this.password = '',
      this.isAdmin = false,
      this.urlPhoto});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'urlPhoto': this.urlPhoto,
    };
  }

  UserModel.fromDoc(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    urlPhoto = json['urlPhoto'];
    isAdmin = json['isAdmin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['urlPhoto'] = this.urlPhoto;

    return data;
  }
}
