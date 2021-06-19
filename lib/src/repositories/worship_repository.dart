import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class WorshipRepository extends ChangeNotifier {
  CollectionReference ref = FirebaseFirestore.instance.collection('worships');

  List<Worship> _worships;
  bool _loading = false;

  WorshipRepository() {
    _getList();
  }

  List<Worship> get worships => _worships;

  bool get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future<void> save(Worship worship) async {
    loading = true;
    await ref.add(worship.toMap);
    _worships.add(worship);
    loading = false;
  }

  Future<void> _getList() async {
    loading = true;
    _worships = [];
    Worship w;

    try {
      await ref.orderBy('dateTime').get().then((values) async {
        for (DocumentSnapshot doc in values.docs) {
          w = Worship.fromDoc(doc);
          await _getUser(w.userId).then((usr) => w.user = usr);
          _worships.add(w);
        }
      });
      // await makeWorship();
    } catch (e) {
      _worships = [];
      loading = false;
      debugPrint('Erro lendo lista de eventos: $e');
    }
    loading = false;
  }

  Future<UserModel> _getUser(String userId) async {
    UserModel user = new UserModel();
    try {
      await UserManager().userById(userId).then((usr) {
        user = usr;
      });
    } catch (err) {
      loading = false;
      debugPrint(err);
    }
    return user;
  }

  Future<void> delete(String worshipId,
      {Function onSucess, Function onError}) async {
    loading = true;
    try {
      await ref.doc(worshipId).delete().onError((err, _) {
        throw (err);
      });
      _worships.removeWhere((w) => w.id == worshipId);
      onSucess();
    } catch (e) {
      loading = false;
      onError(e);
    }
    loading = false;
  }
}
