class Worship {
  DateTime dateTime;
  String description;
  String userAvatar;
  List<Song> songs;

//'https://images.unsplash.com/photo-1598244145083-d46592b3bc4d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTQ2fHxmYWNlJTIwZmVtYWxlJTIwc21pbGluZ3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60'
// Para os testes
  static Worship adoracao() {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 18:30"),
      "description": "Adoração",
      "userAvatar":
          'https://firebasestorage.googleapis.com/v0/b/louvoradbethel.appspot.com/o/izaias4x4.jpg?alt=media&token=dc25b41f-269d-4c33-9255-1ac618377cb0',
      "songs": [
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

//'https://images.unsplash.com/photo-1619263895543-efc4481c7041?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjd8fGZhY2UlMjBmZW1hbGV8ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60',
// Para os testes
  static Worship oferta() {
    Map<String, dynamic> json = {
      "dateTime": DateTime.parse("2020-05-24 20:10"),
      "description": "Oferta",
      "userAvatar":
          'https://firebasestorage.googleapis.com/v0/b/louvoradbethel.appspot.com/o/luciete2x2.png?alt=media&token=69160f89-2e6f-4c32-8f5a-1f481b74897b',
      "songs": [
        {"id": 123, "title": "Aquieta minh'alma"}
      ]
    };
    return new Worship.fromJson(json);
  }

  Worship({this.dateTime, this.description, this.userAvatar, this.songs});

  Worship.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    description = json['description'];
    userAvatar = json['userAvatar'];
    if (json['songs'] != null) {
      songs = <Song>[];
      json['songs'].forEach((v) {
        songs.add(new Song.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['description'] = this.description;
    data['userAvatar'] = this.userAvatar;
    if (this.songs != null) {
      data['songs'] = this.songs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Song {
  int id;
  String title;

  Song({this.id, this.title});

  Song.fromJson(Map<String, dynamic> json) {
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
