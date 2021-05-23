import 'package:firebase_storage/firebase_storage.dart';
import 'package:louvor_bethel/models/worship.dart';

class WorshipProvider {
  static Future<String> urlPhoto(String uid) async {
    String url;
    try {
      Reference ref = FirebaseStorage.instance.ref().child('users/$uid');
      await ref.getDownloadURL().then((value) => url = value);
    } catch (_) {}
    return url;
  }

  // Para os testes
  static Future<Worship> adoracao() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 18:30"),
      "description": "Adoração",
      "userId": "eci5UOc0KJTO7lBV7uwpiwABfO62}",
      "userName": "Izaias Lima",
      "userAvatar": '',
      "songs": [
        {"id": 123, "title": "Ao único que digno"},
        {"id": 323, "title": "Grande é  Senhor"},
        {"id": 232, "title": "Tua mão forte"},
        {"id": 432, "title": "Que se abram os céus"},
        {"id": 456, "title": "Ele é exaltado"},
        {"id": 321, "title": "Yeshua"}
      ]
    };
    Worship w = Worship.fromJson(json);
    w.userAvatar = await urlPhoto(w.userId);
    return w;
  }

// Para os testes
  static Future<Worship> oferta() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 20:10"),
      "description": "Oferta",
      "userId": "rAUWXjFCCSg2oporfpplr4cUHyt1",
      "userName": "Usuário Dois",
      "userAvatar": '',
      "songs": [
        {"id": 123, "title": "Aquieta minh'alma"}
      ]
    };
    Worship w = Worship.fromJson(json);
    w.userAvatar = await urlPhoto(w.userId);
    return w;
  }
}
