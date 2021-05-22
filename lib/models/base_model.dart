import 'package:flutter/material.dart';

import 'package:louvor_bethel/enum/states.dart';
import 'package:louvor_bethel/models/user.dart';

class BaseModel extends ChangeNotifier {
  UserModel _user;
  ViewState _viewState;
  AuthState _authState = AuthState.SignIn;

  get viewState => _viewState;
  get authState => _authState;
  get user => _user;

  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
