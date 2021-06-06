import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';

class LyricRepository extends UserManager {
  final refLyrics = FirebaseFirestore.instance.collection('lyrics');
  LyricModel _lyric;
  List<LyricModel> _lyrics;

  LyricRepository() {
    _getList();
  }

  List get lyrics => _lyrics;

  LyricModel get lyric => _lyric;

  Future<LyricModel> lyricById(String id) async {
    LyricModel lyric;
    try {
      await refLyrics.doc(id).get().then((doc) {
        lyric = LyricModel.fromJson(doc.data());
        lyric.id = id;
      });
    } catch (_) {}
    return lyric;
  }

  Future<void> _getList() async {
    _lyrics = [];
    viewState = ViewState.Busy;
    try {
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

  Future<List<LyricModel>> getListByStyle(String style) async {
    _lyrics = [];
    try {
      await refLyrics
          .where('style', arrayContains: style.toUpperCase())
          .get()
          .then((value) {
        for (DocumentSnapshot doc in value.docs) {
          LyricModel lyric = LyricModel.fromJson(doc.data());
          lyric.id = doc.reference.id;
          _lyrics.add(lyric);
        }
      });
    } catch (_) {}
    return _lyrics;
  }

  Future<void> saveLyric(LyricModel newLyric,
      {Function onSucess, Function onError}) async {
    viewState = ViewState.Busy;
    newLyric.userId = user.id ?? '';

    try {
      var doc;

      if (newLyric.id == null) {
        doc = await refLyrics.add(newLyric.toMap());
        newLyric.id = doc.id;
        _lyrics.add(newLyric);
      } else {
        await refLyrics.doc(newLyric.id).set(newLyric.toMap());
      }

      onSucess(newLyric.id);
    } on Exception catch (e) {
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
        }
      });

      lyric.pdfUrl = await _getUrlPdf(pdfName);
      saveLyric(lyric);

      onSucess('ok');
    } on Exception catch (e) {
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
}
