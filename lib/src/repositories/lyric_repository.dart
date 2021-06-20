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
  UserModel user;
  String _search = '';
  bool _loading = false;

  final refLyrics = FirebaseFirestore.instance.collection('lyrics');
  final storage = FirebaseStorage.instance;

  String get search => _search.toLowerCase();

  set search(String value) {
    _search = value ?? '';
    notifyListeners();
  }

  List<LyricModel> get filteredLyrics {
    List<LyricModel> filtered = [];

    if (search == null || search.isEmpty) {
      filtered.addAll(_lyrics);
    } else {
      filtered.addAll(lyrics.where((l) =>
          l.title.toLowerCase().contains(search) ||
          l.stanza.toLowerCase().contains(search) ||
          l.chorus.toLowerCase().contains(search)));
    }
    return filtered;
  }

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
    try {
      return _lyrics.isNotEmpty ? _lyrics.firstWhere((e) => e.id == id) : null;
    } catch (_) {
      return new LyricModel(id: null, title: 'Música excluída');
    }
  }

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
}
