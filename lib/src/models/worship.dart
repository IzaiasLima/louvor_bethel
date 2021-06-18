import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';

class Worship {
  String id;
  DateTime dateTime;
  String description;
  String userId;
  UserModel user;
  List<Map<String, dynamic>> lyrics;

  Worship();

  Worship.fromDoc(DocumentSnapshot doc) {
    id = doc.id;
    dateTime = doc['dateTime'].toDate();
    description = doc['description'];
    userId = doc['userId'];
    lyrics = [];
    if (doc['lyrics'] != null) {
      // doc['lyrics'].forEach((v) => lyrics.add(LyricModel.fromMap(v)));
      doc['lyrics'].forEach((v) => lyrics.add(v));
    }
  }

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    lyrics = [];
    if (json['lyrics'] != null) {
      json['lyrics'].forEach((v) {
        lyrics.add(LyricModel().toBasicMap());
        // lyrics.add(new LyricModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> get toMap {
    final data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    data['userId'] = this.userId;
    if (this.lyrics != null) {
      // data['lyrics'] = this.lyrics.map((v) => v.toJson()).toList();
      data['lyrics'] = this.lyrics;
    }
    return data;
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
