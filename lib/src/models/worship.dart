import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';

class Worship {
  String id;
  DateTime dateTime;
  String description;
  String userId;
  UserModel user;
  List<LyricModel> lyrics;

  Worship();

  Worship.fromDoc(DocumentSnapshot doc) {
    id = doc.id;
    dateTime = doc['dateTime'].toDate();
    description = doc['description'];
    userId = doc['userId'];
    lyrics = <LyricModel>[];
    if (doc['lyrics'] != null) {
      doc['lyrics'].forEach((v) => lyrics.add(LyricModel.fromMap(v)));
    }
  }

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    lyrics = <LyricModel>[];
    if (json['lyrics'] != null) {
      json['lyrics'].forEach((v) {
        lyrics.add(new LyricModel.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['dateTime'] = this.dateTime;
  //   data['description'] = this.description;
  //   data['userId'] = this.userId;
  //   data['lyrics'] = this.lyrics.map((v) => v.toJson()).toList();
  //   return data;
  // }
}
