import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends ChangeNotifier {
  final UserModel user;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');

  UserRepository(this.user);

  Future<void> save() async {
    await ref.doc(user.id).set(user.toMap());
    notifyListeners();
  }
}
