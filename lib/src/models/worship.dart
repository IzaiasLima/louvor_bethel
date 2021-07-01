import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:louvor_bethel/src/models/schedule.dart';
import 'package:louvor_bethel/src/models/user.dart';

class Worship {
  String id;
  DateTime dateTime;
  String description;
  String userId;
  UserModel user;
  List<Map<String, dynamic>> songs;
  Schedule schedule = new Schedule();

  Worship();

  Worship.fromDoc(DocumentSnapshot doc) {
    id = doc.id;
    dateTime = doc['dateTime'].toDate();
    description = doc['description'];
    userId = doc['userId'];
    songs = [];
    if (doc['songs'] != null) doc['songs'].forEach((v) => songs.add(v));
    schedule = Schedule.fromDoc(doc['schedule']);
  }

  Map<String, dynamic> get toMap {
    final data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['dateTime'] = this.dateTime;
    data['userId'] = this.userId;
    if (this.songs != null) data['songs'] = this.songs;
    data['schedule'] = this.schedule.toMap;

    return data;
  }
}
