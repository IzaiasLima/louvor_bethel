import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/enum/states.dart';
import 'package:louvor_bethel/src/models/base_model.dart';

class DatabaseModel extends BaseModel {
  final firestore = FirebaseFirestore.instance;
  CollectionReference _db;

  DatabaseModel(String dbName) {
    _db = firestore.collection(dbName);
  }

  get db => _db;

  getDoc(String id) {
    var doc;
    setViewState(ViewState.Busy);
    doc = _db.doc(id);
    setViewState(ViewState.Ready);
    return doc;
  }

  list(String field) async {
    var docs;
    setViewState(ViewState.Busy);
    docs = _db.orderBy(field).snapshots();
    setViewState(ViewState.Ready);
    return docs;
  }
}
