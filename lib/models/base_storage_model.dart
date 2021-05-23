import 'package:flutter/material.dart';

import 'package:louvor_bethel/enum/states.dart';

class BaseStorageModel extends ChangeNotifier {
  ImageProvider<Object> _image;
  ViewState _viewState;

  get viewState => _viewState;
  get image => _image;

  setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  setImage(ImageProvider<Object> image) {
    _image = image;
    notifyListeners();
  }
}
