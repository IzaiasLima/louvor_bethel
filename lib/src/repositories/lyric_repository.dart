import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';

class LyricRepository extends UserManager {
  final reference = FirebaseFirestore.instance.collection('lyrics');
  LyricModel _lyric;
  List _lyrics;

  LyricRepository() {
    _getList();
  }

  // get lyric {
  //   return LyricModel.fromJson({
  //     'title': 'Ele é exaltado',
  //     'tone': 'G#+',
  //     'style': ['ADORAÇÃO'],
  //     'stanza': 'Ele é exaltado, o Rei é exaltado nos céus',
  //     'chorus': 'Ele é o Senhor, Sua verdade vai sempre reinar',
  //     'pdfUrl': 'none',
  //     'videoUrl': 'none',
  //     'userId': 'eci5UOc0KJTO7lBV7uwpiwABfO62'
  //   });
  // }

  List get lyrics => _lyrics;

  LyricModel get lyric => _lyric;

  Future<LyricModel> lyricById(String id) async {
    // viewState = ViewState.Busy;
    LyricModel lyric;
    try {
      await reference.doc(id).get().then((doc) {
        lyric = LyricModel.fromJson(doc.data());
      });
      // viewState = ViewState.Ready;
    } catch (e) {
      // viewState = ViewState.Error;
    }
    return lyric;
  }

  Future<void> _getList() async {
    _lyrics = [];
    viewState = ViewState.Busy;
    try {
      await reference.orderBy('title').get().then((value) {
        for (DocumentSnapshot doc in value.docs) {
          LyricModel lyric = LyricModel.fromJson(doc.data());
          lyric.id = doc.reference.id;
          _lyrics.add(lyric);
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
      var doc = await reference.add(newLyric.toMap());
      newLyric.id = doc.id;
      _lyrics.add(newLyric);

      onSucess();
    } on FirebaseException catch (e) {
      onError(e);
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }
}
