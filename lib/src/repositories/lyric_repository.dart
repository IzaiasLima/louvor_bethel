import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/enum/states.dart';
import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/repositories/interfaces/ILyricRepository.dart';

class LyricRepository extends BaseModel implements ILyricRepository {
  FirebaseFirestore firestore;
  List<LyricModel> _lyrics;

  LyricRepository(this.firestore) {
    setViewState(ViewState.Busy);
  }

  get lyric {
    return LyricModel.fromJson({
      'title': 'Ele é exaltado',
      'tone': 'G#+',
      'style': ['ADORAÇÃO'],
      'stanza': 'Ele é exaltado, o Rei é exaltado nos céus',
      'chorus': 'Ele é o Senhor, Sua verdade vai sempre reinar',
      'pdfUrl': 'none',
      'videoUrl': 'none',
      'userId': 'eci5UOc0KJTO7lBV7uwpiwABfO62'
    });
  }

  get lyrics => _lyrics;

  @override
  void get() {
    setViewState(ViewState.Busy);
    try {
      var snap = firestore.collection('lyrics').orderBy('title').snapshots();

      snap.map((query) {
        query.docs.map((doc) {
          print('************** $doc **************8');
          return LyricModel.fromDocument(doc);
        }).toList();
      });
      setViewState(ViewState.Ready);
    } catch (e) {
      print('Erro: $e');
      setViewState(ViewState.Error);
    }
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
  Future delete(LyricModel model) {
    return model.id.delete();
  }
}
