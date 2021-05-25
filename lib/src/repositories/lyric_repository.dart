import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/interfaces/ILyricRepository.dart';

class LyricRepository extends Disposable implements ILyricRepository {
  FirebaseFirestore firestore;

  LyricRepository({@required this.firestore});
  @override
  Future delete(LyricModel model) {
    return model.id.delete();
  }

  @override
  Future<Stream<List<Iterable<LyricModel>>>> get() {
    return firestore
        .collection('lyrics')
        .orderBy('title')
        .snapshots()
        .map((query) => query.docs.map((doc) => LyricModel.fromDocument(doc)))
        .toList();
  }

  @override
  Future save(LyricModel model) async {
    if (model.id == null) {
      model.id = await firestore.collection('lyrics').add(model.toJson());
    } else {
      model.id.update(model.toJson());
    }
  }

  @override
  FutureOr onDispose() {}
}
