class Lyric {
  String id;
  String title;
  String tone;
  String styles;
  String stanza;
  String chorus;
  String videoUrl;
  String userId;
  bool hasPdf;
  bool selected;

  Lyric({
    this.id,
    this.title,
    this.tone,
    this.styles,
    this.stanza,
    this.chorus,
    this.videoUrl,
    this.userId,
    this.hasPdf = false,
    this.selected,
  });

  Lyric.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
  }

  Lyric.fromDoc(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tone = json['tone'];
    styles = json['styles'];
    stanza = json['stanza'];
    chorus = json['chorus'];
    videoUrl = json['videoUrl'];
    userId = json['userId'];
    hasPdf = json['hasPdf'] ?? false;
    selected = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'stanza': this.stanza,
      'chorus': this.chorus,
      'styles': this.styles,
      'tone': this.tone,
      'videoUrl': this.videoUrl,
      'hasPdf': this.hasPdf ?? false,
    };
  }

  Map<String, String> toBasicMap() {
    return {
      'id': this.id,
      'title': this.title,
    };
  }
}
