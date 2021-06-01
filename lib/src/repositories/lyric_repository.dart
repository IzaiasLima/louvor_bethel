import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';

class LyricRepository extends BaseModel {
  // FirebaseFirestore db = FirebaseFirestore.instance;
  final reference = FirebaseFirestore.instance.collection('lyrics');
  List _lyrics = [];

  LyricRepository() {
    _load();
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

  void _load() async {
    viewState = ViewState.Busy;
    try {
      await reference.get().then((value) {
        for (DocumentSnapshot doc in value.docs) {
          _lyrics.add(LyricModel.fromJson(doc.data()));
        }
      });
      viewState = ViewState.Ready;
    } catch (e) {
      viewState = ViewState.Error;
    }
  }

  Future<void> save(
      {LyricModel newLyric, Function onSucess, Function onError}) async {
    viewState = ViewState.Busy;

    newLyric.userId = user.id ?? '';

    try {
      await reference.add(newLyric.toMap());

      onSucess();
    } on FirebaseException catch (e) {
      onError(e);
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }
}
