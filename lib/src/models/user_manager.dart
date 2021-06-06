import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/user.dart';

class UserManager extends BaseModel {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebase = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final refUser = FirebaseFirestore.instance.collection('users');

  UserManager() {
    _loadCurrentUser();
  }

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
      onError(_errorMessage(e.code));
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
      await save();

      onSucess();
    } on FirebaseAuthException catch (e) {
      onError(_errorMessage(e.code));
    }
    viewState = ViewState.Ready;
  }

  Future<void> logOut() async {
    viewState = ViewState.Busy;
    auth.signOut();
    this.user = new UserModel();
    viewState = ViewState.Ready;
  }

  Future<void> save() async {
    viewState = ViewState.Busy;
    await refUser.doc(user.id).set(user.toMap());
    viewState = ViewState.Ready;
  }

  void _loadCurrentUser({User usr}) async {
    viewState = ViewState.Busy;
    User currentUser = usr ?? auth.currentUser;
    if (currentUser != null) {
      this.user = await userById(currentUser.uid);
    }
    viewState = ViewState.Ready;
  }

  Future<UserModel> userById(String uid) async {
    UserModel tmp;

    if (uid != null) {
      var doc = await firebase.collection('users').doc(uid).get();
      if (doc.data() != null) tmp = UserModel.fromJson(doc.data());
      tmp.id = uid;
      try {
        if (tmp.urlPhoto != null) tmp.photo = _loadPhoto(tmp);
      } catch (_) {}
    }
    return tmp;
  }

  Image _loadPhoto(UserModel user) {
    Image photo;
    try {
      if (user.urlPhoto != null) photo = Image.network(user.urlPhoto);
    } catch (_) {
      photo = Image.asset('assets/images/user_avatar.png');
    }
    return photo;
  }

  Future<void> uploadImage(String uid) async {
    viewState = ViewState.Busy;
    if (uid != null) {
      PickedFile pickedFile = await _imagePicker();
      Reference refImage = storage.ref().child('users/$uid');

      UploadTask uploadTask = refImage.putData(await pickedFile.readAsBytes());

      uploadTask.whenComplete(() async {
        TaskSnapshot task = uploadTask.snapshot;
        String url = await task.ref.getDownloadURL();

        user.urlPhoto = url;
        user.photo = Image.network(url);
      });
    }
    viewState = ViewState.Ready;
  }

  Future<PickedFile> _imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 400.0,
      maxWidth: 400.0,
      imageQuality: 90,
    );
    return compressedImage;
  }

  String _errorMessage(code) {
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
