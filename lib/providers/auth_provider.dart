import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:louvor_bethel/models/user.dart';

enum Status { Waitting, Authenticated, Unauthenticated, Completed }

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  Status _status = Status.Waitting;

  Status get status => _status;
  Stream<UserModel> get user =>
      _auth.authStateChanges().map((dbUser) => _userFrom(dbUser));

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen(onStateChanged);
  }

  UserModel _userFrom(User firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }

    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  Future<void> onStateChanged(User dbUser) async {
    if (dbUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _userFrom(dbUser);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final db = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return _userFrom(db.user);
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user != null) {
        _userFrom(result.user);
        _status = Status.Authenticated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
