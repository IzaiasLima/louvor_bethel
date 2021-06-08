import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class LyricRepository extends UserManager {
  final refLyrics = FirebaseFirestore.instance.collection('lyrics');
  LyricModel _lyric;
  List<LyricModel> _lyrics;
  List<Worship> _worships;

  LyricRepository() {
    _getList();
    _getWorshipList();
  }

  List get lyrics => _lyrics;

  List get worships => _worships;

  LyricModel get lyric => _lyric;

  Future<LyricModel> lyricById(String id) async {
    LyricModel lyric;
    try {
      await refLyrics.doc(id).get().then((doc) {
        lyric = LyricModel.fromJson(doc.data());
      });
      lyric.id = id;
    } catch (_) {}
    return lyric;
  }

  Future<void> _getList() async {
    viewState = ViewState.Busy;
    try {
      _lyrics = [];
      await refLyrics.orderBy('title').get().then((value) {
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

  // Future<List<LyricModel>> getListByStyle(String style) async {
  //   _lyrics = [];
  //   try {
  //     await refLyrics
  //         .where('style', arrayContains: style.toUpperCase())
  //         .get()
  //         .then((value) {
  //       for (DocumentSnapshot doc in value.docs) {
  //         LyricModel lyric = LyricModel.fromJson(doc.data());
  //         lyric.id = doc.reference.id;
  //         _lyrics.add(lyric);
  //       }
  //     });
  //   } catch (_) {}
  //   return _lyrics;
  // }

  Future<void> _saveLyric(LyricModel newLyric) async {
    if (newLyric.id == null) {
      var doc = await refLyrics.add(newLyric.toMap());
      newLyric.id = doc.id;
      _lyrics.add(newLyric);
    } else {
      await refLyrics.doc(newLyric.id).set(newLyric.toMap());
    }
  }

  Future<void> saveLyric(LyricModel newLyric,
      {Function onSucess, Function onError}) async {
    viewState = ViewState.Busy;
    newLyric.userId = user.id ?? '';

    try {
      await _saveLyric(newLyric);
      await _getList();
      onSucess(newLyric.id);
    } catch (e) {
      onError(e);
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }

  Future<void> uploadPdf(LyricModel lyric,
      {Function onSucess, Function onError}) async {
    String pdfName = '${lyric.id}.pdf';
    try {
      await FilePicker.platform
          .pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
              allowMultiple: false,
              withData: true)
          .then((value) {
        if (value != null) {
          viewState = ViewState.Busy;
          Uint8List fileBytes = value.files.first.bytes;
          storage.ref('lyrics/$pdfName').putData(fileBytes);
        } else {
          throw ('Arquivo não selecionado.');
        }
      });

      lyric.pdfUrl = await _getUrlPdf(pdfName);
      await _saveLyric(lyric);
      onSucess(lyric.pdfUrl);
    } catch (e) {
      onError('Erro anexando PDF: $e.');
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }

  Future<String> _getUrlPdf(String pdfName) async {
    String url = '';

    try {
      Reference refPdf = storage.ref().child('lyrics/$pdfName');
      url = await refPdf.getDownloadURL().then((value) => value);
    } catch (_) {}

    return url;
  }

  Future<void> deleteLyric(String lyricId,
      {Function onSucess, Function onError}) async {
    viewState = ViewState.Busy;

    try {
      await _deletePdf(lyricId);
      await refLyrics.doc(lyricId).delete().onError((err, _) {
        throw (err);
      });
      await _getList();
      onSucess();
    } catch (e) {
      onError(e);
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }

  Future<void> _deletePdf(String lyricId) async {
    try {
      await storage.ref('lyrics/$lyricId').delete();
    } catch (_) {}
  }

// Testes
  Future<void> getAdoracao() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2021-06-24 18:30"),
      "description": "Adoração",
      "userId": "GiDRCTJds1Rzbkh27ysDN5xUYaZ2",
    };
    Worship w = Worship.fromJson(json);
    _lyrics.removeLast();
    w.lyrics.addAll(_lyrics);
    await getWorshipWithUser(w);
    _worships.add(w);
  }

// Testes
  Future<void> _getWorshipList() async {
    viewState = ViewState.Busy;
    await getAdoracao();
    await getOferta();
    viewState = ViewState.Ready;
  }

// Testes
  Future<void> getOferta() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("20201-06-24 20:10"),
      "description": "Oferta",
      "userId": "akmG1s9NXpaIZJeFLbG5wuJBKad2",
    };
    Worship w = Worship.fromJson(json);
    w.lyrics.add(_lyrics.last);
    await getWorshipWithUser(w);
    _worships.add(w);
  }

  static Future<Worship> getWorshipWithUser(Worship worship) async {
    try {
      await UserManager().userById(worship.userId).then((usr) {
        worship.user = usr;
      });
    } on Exception catch (_) {
      worship.user = new UserModel();
    }
    return worship;
  }
}
