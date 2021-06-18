import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class WorshipRepository extends ChangeNotifier {
  CollectionReference worshioRef =
      FirebaseFirestore.instance.collection('worships');

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
    await worshioRef.add(worship.toMap);
    loading = false;
  }

  Future<void> _getList() async {
    loading = true;
    _worships = [];
    Worship w;

    try {
      await worshioRef.orderBy('dateTime').get().then((values) async {
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
}
