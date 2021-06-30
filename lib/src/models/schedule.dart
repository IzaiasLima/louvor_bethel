class Schedule {
  String leadSinger;
  String backingVocals;
  String keyboard;
  String acoustGuitar;
  String guitar;
  String bass;
  String drums;
  String backupMusician;
  String backupVocal;

  Schedule(
      {this.leadSinger,
      this.backingVocals,
      this.keyboard,
      this.acoustGuitar,
      this.guitar,
      this.bass,
      this.drums,
      this.backupMusician,
      this.backupVocal});

  Schedule.fromJson(Map<String, dynamic> json) {
    leadSinger = json['leadSinger'];
    backingVocals = json['backingVocals'];
    keyboard = json['keyboard'];
    acoustGuitar = json['acoustGuitar'];
    guitar = json['guitar'];
    bass = json['bass'];
    drums = json['drums'];
    backupMusician = json['backupMusician'];
    backupVocal = json['backupVocal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadSinger'] = this.leadSinger;
    data['backingVocals'] = this.backingVocals;
    data['keyboard'] = this.keyboard;
    data['acoustGuitar'] = this.acoustGuitar;
    data['guitar'] = this.guitar;
    data['bass'] = this.bass;
    data['drums'] = this.drums;
    data['backupMusician'] = this.backupMusician;
    data['backupVocal'] = this.backupVocal;
    return data;
  }

  Schedule.fromText(String txt) {
    if (txt.startsWith('Schedule')) {
      var list = txt.split(',');
      if (list.length == 10) {
        leadSinger = list[1];
        backingVocals = list[2];
        keyboard = list[3];
        acoustGuitar = list[4];
        guitar = list[5];
        bass = list[6];
        drums = list[7];
        backupMusician = list[8];
        backupVocal = list[9];
      }
    }
  }

  @override
  String toString() {
    return 'Schedule, ${this.leadSinger ?? ''}, ${this.backingVocals ?? ''}, ${this.keyboard ?? ''}, ${this.acoustGuitar ?? ''}, ${this.guitar ?? ''}, ${this.bass ?? ''}, ${this.drums ?? ''}, ${this.backupMusician ?? ''}, ${this.backupVocal ?? ''}';
  }
}
