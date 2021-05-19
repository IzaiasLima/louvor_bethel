import 'package:firebase_auth/firebase_auth.dart';

import 'package:louvor_bethel/enum/states.dart';
import 'package:louvor_bethel/models/base_model.dart';

class AuthModel extends BaseModel {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  createNewUser(String email, String password) async {
    setViewState(ViewState.Busy);
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      setViewState(ViewState.Ready);
    } on Exception catch (_) {
      setViewState(ViewState.Error);
    }
  }

  passwordReset(String email) async {
    setViewState(ViewState.Busy);
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      setViewState(ViewState.Ready);
    } on Exception catch (_) {
      setViewState(ViewState.Error);
    }
  }

  signIn(String email, String password) async {
    setViewState(ViewState.Busy);
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      setViewState(ViewState.Ready);
    } on Exception catch (_) {
      setViewState(ViewState.Refused);
    }
  }

  logOut() async {
    setViewState(ViewState.Busy);
    await firebaseAuth.signOut();
    setViewState(ViewState.Ready);
  }
}
