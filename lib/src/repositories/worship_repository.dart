import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';

class WorshipRepository extends BaseModel {
  Future<List<Worship>> list() async {
    List<Worship> wshp = [];
    wshp.add(await adoracao());
    wshp.add(await oferta());

    return wshp;
  }

  // Para os testes
  static Future<Worship> adoracao() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 18:30"),
      "description": "Adoração",
      "userId": "GiDRCTJds1Rzbkh27ysDN5xUYaZ2",
      "user": '',
      "lyrics": [
        {"id": '123', "title": "Ao único que digno"},
        {"id": '323', "title": "Grande é Senhor"},
        {"id": '232', "title": "Tua mão forte"},
        {"id": '432', "title": "Que se abram os céus"},
        {"id": '456', "title": "Ele é exaltado"},
        {"id": '321', "title": "Yeshua"}
      ]
    };
    Worship w = Worship.fromJson(json);
    return await getWorshipWithUser(w);
  }

// Para os testes
  static Future<Worship> oferta() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 20:10"),
      "description": "Oferta",
      "userId": "akmG1s9NXpaIZJeFLbG5wuJBKad2",
      "user": '',
      "lyrics": [
        {"id": '123', "title": "Aquieta minh'alma"}
      ]
    };
    Worship w = Worship.fromJson(json);
    return await getWorshipWithUser(w);
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
