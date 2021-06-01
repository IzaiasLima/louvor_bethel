import 'package:louvor_bethel/src/models/lyric_model.dart';

class Worship {
  DateTime dateTime;
  String description;
  String userId;
  String userName;
  String userAvatar;
  List<LyricModel> lyrics;

  // Worship({this.dateTime, this.description, this.userAvatar, this.songs});

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    userName = json['userName'];
    // userAvatar = json['userAvatar'];
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
    data['userName'] = this.userName;
    // data['userAvatar'] = this.userAvatar;
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
