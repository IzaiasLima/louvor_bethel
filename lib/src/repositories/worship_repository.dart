import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:louvor_bethel/src/commons/datetime_helper.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class WorshipRepository extends ChangeNotifier {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('worships');

  List<Worship> _worships;
  bool _loading = false;

  WorshipRepository() {
    _getList();
  }

  List<Worship> get worships => _worships;

  bool get loading => _loading;

  get weekOfset => null;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  List<Worship> getWeekWorships(int ofset) {
    DateTime start = DateTimeHelper.getWeekFilter(offset: ofset)['weekStart'];
    DateTime end = DateTimeHelper.getWeekFilter(offset: ofset)['weekEnd'];

    List<Worship> weekWorships = _worships
        .where((w) => (w.dateTime.isAfter(start) && w.dateTime.isBefore(end)))
        .toList();
    return weekWorships;
  }

  Future<void> _getList() async {
    loading = true;
    _worships = [];
    Worship w;

    try {
      await collection
          .orderBy('dateTime', descending: true)
          .limit(100)
          .get()
          .then((values) async {
        for (DocumentSnapshot doc in values.docs) {
          w = Worship.fromDoc(doc);
          await _getUser(w.userId).then((usr) => w.user = usr);
          _worships.add(w);
        }
      });
    } catch (e) {
      _worships = [];
      loading = false;
      debugPrint('Erro lendo lista de eventos: $e');
    }
    loading = false;
  }

  refreshList(int ofset) {
    _getList();
    getWeekWorships(ofset);
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

  Future<void> save(Worship worship) async {
    loading = true;
    try {
      await collection.add(worship.toMap);
      _worships.add(worship);
      loading = false;
    } catch (e) {
      loading = false;
      debugPrint(e);
    }
  }

  Future<void> update(Worship worship) async {
    loading = true;
    try {
      await collection.doc(worship.id).update(worship.toMap);
      _worships.removeWhere((w) => w.id == worship.id);
      _worships.add(worship);
      loading = false;
    } catch (_) {
      loading = false;
    }
  }

  Future<void> delete(String worshipId,
      {Function onSucess, Function onError}) async {
    loading = true;
    try {
      await collection.doc(worshipId).delete().onError((err, _) {
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
