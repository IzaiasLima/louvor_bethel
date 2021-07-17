import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:louvor_bethel/src/models/lyric.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/repositories/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class LyricRepository extends ChangeNotifier {
  List<Lyric> _lyrics = [];
  List<Worship> _worships = [];
  UserModel user;
  String _search = '';
  bool _loading = false;
  String _url = '';
  int _uploadProgress = 0;

  final refLyrics = FirebaseFirestore.instance.collection('lyrics');
  final storage = FirebaseStorage.instance;

  String get search => _search.toLowerCase();
  String get url => _url;

  get isLoading => _loading;

  get progress => _uploadProgress;

  List get lyrics => _lyrics;

  List get worships => _worships;

  List<Lyric> get filteredLyrics {
    List<Lyric> filtered = [];

    if (search == null || search.isEmpty) {
      filtered.addAll(_lyrics);
    } else {
      filtered.addAll(lyrics.where((l) =>
          l.title.toLowerCase().contains(search) ||
          l.stanza.toLowerCase().contains(search) ||
          l.chorus.toLowerCase().contains(search) ||
          l.styles.toLowerCase().contains(search)));
    }
    return filtered;
  }

  set isLoading(bool state) {
    _loading = state;
    notifyListeners();
  }

  Lyric lyricById(String id) {
    try {
      return _lyrics.isNotEmpty ? _lyrics.firstWhere((e) => e.id == id) : null;
    } catch (_) {
      return new Lyric(id: null, title: 'Música excluída');
    }
  }

  set search(String value) {
    _search = value ?? '';
    notifyListeners();
  }

  Future<void> _getList() async {
    isLoading = true;
    try {
      _lyrics = [];
      await refLyrics.orderBy('title').get().then((value) {
        for (DocumentSnapshot doc in value.docs) {
          Lyric lyric = Lyric.fromDoc(doc.data());
          lyric.id = doc.reference.id;
          _lyrics.add(lyric);
        }
      });
    } catch (e) {
      isLoading = false;
      debugPrint('Erro obtendo a lista: $e');
    }
    isLoading = false;
  }

  refreshList() {
    _getList();
  }

  Future<void> save(Lyric lyric,
      {@required Function onSucess, @required Function onError}) async {
    isLoading = true;

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
      isLoading = false;
      onError(e);
    }
    isLoading = false;
  }

  Future<void> uploadPdf(Lyric lyric,
      {Function onSucess, Function onError}) async {
    isLoading = true;

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
          Uint8List fileBytes = value.files.first.bytes;
          UploadTask task = storage.ref('lyrics/$pdfName').putData(fileBytes);

          task.snapshotEvents.listen((event) {
            _uploadProgress =
                (100 * event.bytesTransferred ~/ event.totalBytes);
            notifyListeners();
          });
        } else {
          throw ('Arquivo não selecionado.');
        }

        Future.delayed(Duration(seconds: 5)).then((value) => isLoading = false);
      });

      await setUrlPdf(pdfName);
      lyric.hasPdf = true;
      await save(lyric, onSucess: onSucess, onError: onError);
      onSucess(_url);
    } catch (e) {
      _uploadProgress = 0;
      onError('Erro anexando PDF: $e.');
    }
  }

  Future<void> setUrlPdf(String pdfName) async {
    isLoading = true;
    try {
      Reference refPdf = storage.ref().child('lyrics/$pdfName');
      _url = await refPdf.getDownloadURL().then((value) => value);
      isLoading = false;
    } catch (err) {
      isLoading = false;
      debugPrint('Erro obtendo Url do PDF: $err');
    }
  }

  update(UserManager userManager) {
    this.user = userManager.user;
    _getList();
  }

  Future<void> delete(String lyricId,
      {Function onSucess, Function onError}) async {
    isLoading = true;
    try {
      await _deletePdf(lyricId);
      await refLyrics.doc(lyricId).delete().onError((err, _) {
        throw (err);
      });
      _lyrics.removeWhere((l) => l.id == lyricId);
      onSucess();
    } catch (e) {
      isLoading = false;
      onError(e);
    }
    isLoading = false;
  }

  Future<bool> _deletePdf(String lyricId) async {
    bool result = false;
    try {
      storage
          .ref('lyrics/$lyricId.pdf')
          .delete()
          .whenComplete(() => result = true);
    } catch (e) {
      debugPrint('Erro excluindo PDF: $e');
      result = false;
    }
    return result;
  }
}
