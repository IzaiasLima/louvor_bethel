import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class LyricRepository extends ChangeNotifier {
  List<LyricModel> _lyrics = [];
  List<Worship> _worships = [];
  // LyricModel _lyric = new LyricModel();
  UserModel user;

  bool _loading = false;

  final refLyrics = FirebaseFirestore.instance.collection('lyrics');
  final storage = FirebaseStorage.instance;

  update(UserManager userManager) {
    this.user = userManager.user;
    _getList();
  }

  get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  List get lyrics => _lyrics;

  List get worships => _worships;

  LyricModel lyricById(String id) {
    return _lyrics.firstWhere((e) => e.id == id);
  }

  // LyricModel get lyric => _lyric;

  // Future<void> lyricById(String id) async {
  //   loading = true;
  //   try {
  //     await refLyrics.doc(id).get().then((doc) {
  //       _lyric = LyricModel.fromJson(doc.data());
  //       _lyric.id = id;
  //     });
  //   } catch (err) {
  //     debugPrint(err);
  //   }
  //   loading = false;
  // }

  Future<void> _getList() async {
    loading = true;
    try {
      _lyrics = [];
      await refLyrics.orderBy('title').get().then((value) {
        for (DocumentSnapshot doc in value.docs) {
          LyricModel lyric = LyricModel.fromJson(doc.data());
          lyric.id = doc.reference.id;
          _lyrics.add(lyric);
        }
      });
    } catch (e) {
      loading = false;
      debugPrint('Erro obtendo a lista: $e');
    }
    loading = false;
  }

  Future<void> save(LyricModel lyric,
      {@required Function onSucess, @required Function onError}) async {
    loading = true;

    try {
      lyric.userId = user.id ?? '';
      if (lyric.id == null) {
        var doc = await refLyrics.add(lyric.toMap());
        lyric.id = doc.id;
      } else {
        _lyrics.removeWhere((d) => d.id == lyric.id);
        await refLyrics.doc(lyric.id).update(lyric.toMap());
      }
      lyric.selected = false;
      _lyrics.add(lyric);
      onSucess(lyric.id);
    } catch (e) {
      loading = false;
      onError(e);
    }
    loading = false;
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
          loading = true;
          Uint8List fileBytes = value.files.first.bytes;
          storage.ref('lyrics/$pdfName').putData(fileBytes);
        } else {
          throw ('Arquivo não selecionado.');
        }
      });

      lyric.pdfUrl = await _getUrlPdf(pdfName);
      await save(lyric, onSucess: onSucess, onError: onError);
      onSucess(lyric.pdfUrl);
    } catch (e) {
      loading = false;
      onError('Erro anexando PDF: $e.');
    }
    loading = false;
  }

  Future<String> _getUrlPdf(String pdfName) async {
    String url = '';

    try {
      Reference refPdf = storage.ref().child('lyrics/$pdfName');
      url = await refPdf.getDownloadURL().then((value) => value);
    } catch (err) {
      debugPrint('Erro obtendo Url do PDF: $err');
    }

    return url;
  }

  Future<void> delete(String lyricId,
      {Function onSucess, Function onError}) async {
    loading = true;
    try {
      await _deletePdf(lyricId);
      await refLyrics.doc(lyricId).delete().onError((err, _) {
        throw (err);
      });
      _lyrics.removeWhere((l) => l.id == lyricId);
      onSucess();
    } catch (e) {
      loading = false;
      onError(e);
    }
    loading = false;
  }

  Future<void> _deletePdf(String lyricId) async {
    try {
      await storage.ref('lyrics/$lyricId').delete();
    } catch (err) {
      debugPrint('Erro excluindo PDF: $err');
    }
  }

// s

// // Testes
//   Future<void> _getWorshipList() async {
//     loading = true;
//     await getAdoracao();
//     await getOferta();
//     loading = false;
//   }

// // Testes
//   Future<void> getOferta() async {
//     Map<String, dynamic> json = {
//       "dateTime": DateTime.parse("20201-06-24 20:10"),
//       "description": "Oferta",
//       "userId": "akmG1s9NXpaIZJeFLbG5wuJBKad2",
//     };
//     Worship w = Worship.fromJson(json);
//     w.lyrics.add(_lyrics.last);
//     await getWorshipWithUser(w);
//     _worships.add(w);
//   }

  // static Future<Worship> getWorshipWithUser(Worship worship) async {
  //   try {
  //     await UserManager().userById(worship.userId).then((usr) {
  //       worship.user = usr;
  //     });
  //   } on Exception catch (_) {
  //     worship.user = new UserModel();
  //   }
  //   return worship;
  // }
}
