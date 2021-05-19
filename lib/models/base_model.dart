import 'package:flutter/material.dart';

import 'package:louvor_bethel/enum/states.dart';

class BaseModel extends ChangeNotifier {
  ViewState _viewState;
  AuthState _authState;

  get viewState => _viewState;
  get authState => _authState;

  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  setAuthState(AuthState authState) {
    _authState = authState;
    notifyListeners();
  }
}
