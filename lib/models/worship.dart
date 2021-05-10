class Worship {
  DateTime dateTime;
  String description;
  int userId;
  List<_Lyrics> lyrics;

  static Worship adoracao() {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 18:30"),
      "description": "Adoração",
      "userId": 10,
      "lyrics": [
        {"id": 123, "title": "Ao único que digno"},
        {"id": 323, "title": "Grande é  Senhor"},
        {"id": 232, "title": "Tua mão forte"},
        {"id": 432, "title": "Que se abram os céus"},
        {"id": 456, "title": "Ele é exaltado"},
        {"id": 321, "title": "Yeshua"}
      ]
    };

    return new Worship.fromJson(json);
  }

  Worship({this.dateTime, this.description, this.userId, this.lyrics});

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userId = json['userId'];
    if (json['lyrics'] != null) {
      lyrics = <_Lyrics>[];
      json['lyrics'].forEach((v) {
        lyrics.add(new _Lyrics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['description'] = this.description;
    data['userId'] = this.userId;
    if (this.lyrics != null) {
      data['lyrics'] = this.lyrics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class _Lyrics {
  int id;
  String title;

  _Lyrics({this.id, this.title});

  _Lyrics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
