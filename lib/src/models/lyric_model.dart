class LyricModel {
  String id;
  String title;
  String tone;
  List<String> style;
  String stanza;
  String chorus;
  String pdfUrl;
  String videoUrl;
  String userId;

  LyricModel(
      {this.id,
      this.title,
      this.tone,
      this.style,
      this.stanza,
      this.chorus,
      this.pdfUrl,
      this.videoUrl,
      this.userId});

  LyricModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
  }

  LyricModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    tone = json['tone'];
    style = json['style']?.cast<String>();
    stanza = json['stanza'];
    chorus = json['chorus'];
    pdfUrl = json['pdfUrl'];
    videoUrl = json['videoUrl'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['tone'] = this.tone;
    data['style'] = this.style;
    data['stanza'] = this.stanza;
    data['chorus'] = this.chorus;
    data['pdfUrl'] = this.pdfUrl;
    data['videoUrl'] = this.videoUrl;
    data['userId'] = this.userId;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'stanza': this.stanza,
      'chorus': this.chorus,
      'style': this.style,
      'tone': this.tone,
      'pdfUrl': this.pdfUrl,
      'videoUrl': this.videoUrl,
    };
  }
}
