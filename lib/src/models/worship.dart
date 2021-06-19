import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/models/user.dart';

class Worship {
  String id;
  DateTime dateTime;
  String description;
  String userId;
  UserModel user;
  List<Map<String, dynamic>> songs;

  Worship();

  Worship.fromDoc(DocumentSnapshot doc) {
    id = doc.id;
    dateTime = doc['dateTime'].toDate();
    description = doc['description'];
    userId = doc['userId'];
    songs = [];
    if (doc['songs'] != null) {
      // doc['songs'].forEach((v) => songs.add(LyricModel.fromMap(v)));
      doc['songs'].forEach((v) => songs.add(v));
    }
  }

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    songs = [];
    if (json['songs'] != null) {
      json['songs'].forEach((v) {
        songs.add(LyricModel().toBasicMap());
        // songs.add(new LyricModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> get toMap {
    final data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    data['userId'] = this.userId;
    if (this.songs != null) {
      // data['songs'] = this.songs.map((v) => v.toJson()).toList();
      data['songs'] = this.songs;
    }
    return data;
  }
}
