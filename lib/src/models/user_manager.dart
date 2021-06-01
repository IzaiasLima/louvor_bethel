import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_repository.dart';

class UserManager extends BaseModel {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  UserRepository userRepo;
  // UserModel userModel;

  UserManager() {
    // userModel = new UserModel();
    _loadCurrentUser();
  }

  // ViewState _viewState = ViewState.Ready;

  // ViewState get viewState => _viewState;

  // set viewState(ViewState viewState) {
  //   _viewState = viewState;
  //   notifyListeners();
  // }

  Future<void> signIn(
      {@required UserModel user,
      @required Function onSucess,
      @required Function onError}) async {
    viewState = ViewState.Busy;

    try {
      var result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      _loadCurrentUser(usr: result.user);

      onSucess();
    } on FirebaseAuthException catch (e) {
      onError(errorMessage(e.code));
    }
    viewState = ViewState.Ready;
  }

  Future<void> signUp(
      {@required UserModel newUser,
      @required Function onSucess,
      @required Function onError}) async {
    viewState = ViewState.Busy;

    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: newUser.email, password: newUser.password);

      newUser.id = result.user.uid;
      this.user = newUser;

      await UserRepository(newUser).save();

      onSucess();
    } on FirebaseAuthException catch (e) {
      onError(errorMessage(e.code));
    }
    viewState = ViewState.Ready;
  }

  Future<void> logOut() async {
    viewState = ViewState.Busy;
    auth.signOut();
    this.user = new UserModel();
    viewState = ViewState.Ready;
  }

  void _loadCurrentUser({User usr}) async {
    viewState = ViewState.Busy;
    User currentUser = usr ?? auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      UserModel tmp =
          doc.data() != null ? UserModel.fromJson(doc.data()) : new UserModel();
      tmp.id = currentUser.uid;
      this.user = tmp;
    }
    viewState = ViewState.Ready;
  }

  // bool get loggedIn => this.user.id.isNotEmpty;

  String errorMessage(code) {
    String msg;

    switch (code) {
      case 'user-not-found':
        msg = 'Usuário não cadastrado.';
        break;
      case 'wrong-password':
        msg = 'Senha ou email incorretos.';
        break;
      case 'email-already-in-use':
        msg = 'O email informado já foi cadastrado.';
        break;
      default:
        msg = 'A validação do usuário não foi possível ($code).';
    }
    return msg;
  }
}
