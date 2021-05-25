import 'package:firebase_storage/firebase_storage.dart';

class Api {
  final Reference _ref = FirebaseStorage.instance.ref();

  get db => _ref;

  setDBName(String collection) {
    _ref.child(collection);
  }
}
