import 'package:firebase_auth/firebase_auth.dart';

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

  updateProfiler(String name) async {
    await firebaseAuth.currentUser
        .updateProfile(displayName: name, photoURL: 'null');

    await firebaseAuth.currentUser
        .reload()
        .then((value) => setUser(UserModel.fromAuth(firebaseAuth.currentUser)));
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
      setUser(UserModel.fromAuth(firebaseAuth.currentUser));
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
