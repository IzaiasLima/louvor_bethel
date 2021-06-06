import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';

class WorshipRepository extends BaseModel {
  final repo = new LyricRepository();

  List<Worship> _list = [];

  get list => _list;

  WorshipRepository() {
    _getList();
  }

  Future<void> _getList() async {
    _list.add(await _getAdoracao());
    _list.add(await _getOferta());

    notifyListeners();
  }

  // Para os testes
  Future<Worship> _getAdoracao() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 18:30"),
      "description": "Adoração",
      "userId": "GiDRCTJds1Rzbkh27ysDN5xUYaZ2",
    };
    Worship w = Worship.fromJson(json);
    w.lyrics = await repo.getListByStyle('adoracao');
    return await getWorshipWithUser(w);
  }

// Para os testes
  Future<Worship> _getOferta() async {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 20:10"),
      "description": "Oferta",
      "userId": "akmG1s9NXpaIZJeFLbG5wuJBKad2",
    };
    Worship w = Worship.fromJson(json);
    w.lyrics = await repo.getListByStyle('oferta');
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
