import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';

class Worship {
  DateTime dateTime;
  String description;
  String userId;
  UserModel user;
  List<LyricModel> lyrics;

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    if (json['lyrics'] != null) {
      lyrics = <LyricModel>[];
      json['lyrics'].forEach((v) {
        lyrics.add(new LyricModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['description'] = this.description;
    data['userId'] = this.userId;
    data['lyrics'] = this.lyrics.map((v) => v.toJson()).toList();
    return data;
  }
}

// class LyricModel {
//   int id;
//   String title;

//   // Song({this.id, this.title});

//   LyricModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     return data;
//   }
// }
