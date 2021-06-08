import 'package:louvor_bethel/src/commons/enums/states.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';
import 'package:louvor_bethel/src/models/user_manager.dart';
import 'package:louvor_bethel/src/models/worship.dart';
import 'package:louvor_bethel/src/repositories/lyric_repository.dart';

class WorshipRepository extends LyricRepository {
  List<Worship> _worships;

  WorshipRepository() {
    _getList();
    print(this.lyrics.length);
  }

  get worships => _worships;

  Future<void> _getList() async {
    viewState = ViewState.Busy;
    await getAdoracao();
    await getOferta();
    viewState = ViewState.Ready;
  }

  // Para os testes
  Future<void> getAdoracao() async {
    List<LyricModel> _lyrics;
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2021-06-24 18:30"),
      "description": "Adoração",
      "userId": "GiDRCTJds1Rzbkh27ysDN5xUYaZ2",
    };
    Worship w = Worship.fromJson(json);
    _lyrics = super.lyrics;
    _lyrics.removeLast();
    w.lyrics.addAll(_lyrics);
    await getWorshipWithUser(w);
    _worships.add(w);
  }

// Para os testes
  Future<void> getOferta() async {
    List<LyricModel> _lyrics;
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("20201-06-24 20:10"),
      "description": "Oferta",
      "userId": "akmG1s9NXpaIZJeFLbG5wuJBKad2",
    };
    Worship w = Worship.fromJson(json);
    _lyrics = super.lyrics;
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
