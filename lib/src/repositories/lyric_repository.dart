import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  List get lyrics => _lyrics;

  LyricModel get lyric => _lyric;

  Future<LyricModel> lyricById(String id) async {
    LyricModel lyric;
    try {
      await reference.doc(id).get().then((doc) {
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

  Future<void> saveLyric(
      {LyricModel newLyric, Function onSucess, Function onError}) async {
    viewState = ViewState.Busy;
    newLyric.userId = user.id ?? '';

    try {
      var doc;

      if (newLyric.id == null) {
        doc = await reference.add(newLyric.toMap());
        newLyric.id = doc.id;
        _lyrics.add(newLyric);
      } else {
        await reference.doc(newLyric.id).set(newLyric.toMap());
      }

      onSucess(newLyric.id);
    } on FirebaseException catch (e) {
      onError(e);
      viewState = ViewState.Error;
    }
    viewState = ViewState.Ready;
  }

  Future<void> uploadPdf(LyricRepository repo, String lyricId,
      {Function onSucess, Function onError}) async {
    try {
      await FilePicker.platform
          .pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
              allowMultiple: false,
              withData: true)
          .then((value) {
        if (value != null) {
          Uint8List fileBytes = value.files.first.bytes;
          storage.ref('lyrics/$lyricId.pdf').putData(fileBytes);
        }
      });

      onSucess();
    } on Exception catch (e) {
      onError('Erro anexando PDF: $e.');
    }
  }

  static Future<String> urlPdf(String pdfName) async {
    String url = '';

    try {
      Reference ref = FirebaseStorage.instance.ref();
      ref.child('lyrics/$pdfName.pdf');
      url = await ref.getDownloadURL().then((value) => value);
    } catch (_) {}

    return url;
  }
}
