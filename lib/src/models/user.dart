import 'package:flutter/material.dart';

class UserModel {
  String id;
  String name;
  String email;
  // String urlPhoto;
  Image photo;
  String password;
  String confirmPass;
  bool isAdmin;
  bool isManager;

  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.isAdmin = false,
    this.isManager = false,
    // this.urlPhoto
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      // 'urlPhoto': this.urlPhoto,
      'isAdmin': this.isAdmin ?? false,
      'isManager': this.isManager ?? false,
    };
  }

  UserModel.fromDoc(Map<String, dynamic> doc) {
    email = doc['email'];
    name = doc['name'];
    // urlPhoto = doc['urlPhoto'];
    isAdmin = doc['isAdmin'] ?? false;
    isManager = doc['isManager'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    // data['urlPhoto'] = this.urlPhoto;

    return data;
  }
}
