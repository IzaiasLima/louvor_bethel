class Lyric {
  String id;
  String title;
  String tone;
  // List<String> style;
  String styles;
  String stanza;
  String chorus;
  // String pdfUrl;
  String videoUrl;
  String userId;
  bool hasPdf;
  bool selected;

  Lyric({
    this.id,
    this.title,
    this.tone,
    // this.style,
    this.styles,
    this.stanza,
    this.chorus,
    // this.pdfUrl,
    this.videoUrl,
    this.userId,
    this.hasPdf,
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
    // style = json['style']?.cast<String>();
    styles = json['styles'];
    stanza = json['stanza'];
    chorus = json['chorus'];
    // pdfUrl = json['pdfUrl'];
    videoUrl = json['videoUrl'];
    userId = json['userId'];
    hasPdf = json['hasPdf'] ?? false;
    selected = false;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['title'] = this.title;
  //   data['tone'] = this.tone;
  //   // data['style'] = this.style;
  //   data['styles'] = this.styles;
  //   data['stanza'] = this.stanza;
  //   data['chorus'] = this.chorus;
  //   data['pdfUrl'] = this.pdfUrl;
  //   data['videoUrl'] = this.videoUrl;
  //   data['userId'] = this.userId;
  //   data['hasPdf'] = this.hasPdf;
  //   return data;
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'stanza': this.stanza,
      'chorus': this.chorus,
      // 'style': this.style,
      'styles': this.styles,
      'tone': this.tone,
      // 'pdfUrl': this.pdfUrl,
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
