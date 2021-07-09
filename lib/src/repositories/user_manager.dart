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
  // final FirebaseFirestore firebase = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final users = FirebaseFirestore.instance.collection('users');

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
      viewState = ViewState.Ready;
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
      viewState = ViewState.Ready;
      onError(_errorMessage(e.code));
    }
    viewState = ViewState.Ready;
  }

  Future<void> sendPassResetEmail(
      {@required String email,
      @required Function onSucess,
      @required Function onError}) async {
    viewState = ViewState.Busy;

    try {
      await auth.sendPasswordResetEmail(email: email);
      onSucess();
    } on FirebaseAuthException catch (e) {
      viewState = ViewState.Ready;
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
    await users.doc(user.id).set(user.toMap());
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
      var doc = await users.doc(uid).get();
      if (doc.data() != null) tmp = UserModel.fromDoc(doc.data());
      tmp.id = uid;
      tmp.photo = await _loadPhoto(tmp);
    }
    return tmp;
  }

  Future<Image> _loadPhoto(UserModel user) async {
    Image photo;
    try {
      var urlPhoto = await _getDownloadURL(user.id);
      if (urlPhoto != null) photo = Image.network(urlPhoto);
    } catch (_) {
      photo = Image.asset('assets/images/user_avatar.png');
    }
    return photo;
  }

  Future<String> _getDownloadURL(String uid) async {
    Reference refImage = storage.ref().child('users/$uid');
    String url = await refImage.getDownloadURL();
    return url;
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

        // user.urlPhoto = url;
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
