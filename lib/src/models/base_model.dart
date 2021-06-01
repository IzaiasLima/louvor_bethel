import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/user.dart';

class BaseModel extends ChangeNotifier {
  UserModel _user;
  ViewState _viewState;

  ViewState get viewState => _viewState;
  UserModel get user => _user;
  bool get loggedIn => user != null && user.id != null && user.id.isNotEmpty;

  set viewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
