import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:louvor_bethel/enum/states.dart';
import 'package:louvor_bethel/models/base_model.dart';
import 'package:louvor_bethel/models/user.dart';

class AuthModel extends BaseModel {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  createNewUser(String email, String password) async {
    setViewState(ViewState.Busy);
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      setUser(UserModel.fromAuth(userCredential.user));
      setViewState(ViewState.Ready);
    } on Exception catch (_) {
      setViewState(ViewState.Error);
    }
  }

  updateProfiler(String name, String urlPhoto) async {
    urlPhoto = urlPhoto ?? '';

    await firebaseAuth.currentUser
        .updateProfile(displayName: name, photoURL: urlPhoto);

    await firebaseAuth.currentUser
        .reload()
        .then((_) => setUser(UserModel.fromAuth(firebaseAuth.currentUser)));
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
      UserModel user = UserModel.fromAuth(firebaseAuth.currentUser);
      if (user.photoUrl.isNotEmpty) {
        user.photo = Image.network(user.photoUrl).image;
      } else {
        user.photo = Image.asset('assets/images/user_avatar.png').image;
      }
      setUser(user);
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
