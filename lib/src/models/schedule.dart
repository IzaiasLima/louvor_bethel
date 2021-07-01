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

  Schedule.fromDoc(Map<String, dynamic> doc) {
    leadSinger = doc['leadSinger'];
    backingVocals = doc['backingVocals'];
    keyboard = doc['keyboard'];
    acoustGuitar = doc['acoustGuitar'];
    guitar = doc['guitar'];
    bass = doc['bass'];
    drums = doc['drums'];
    backupMusician = doc['backupMusician'];
    backupVocal = doc['backupVocal'];
  }

  Map<String, dynamic> get toMap {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leadSinger'] = this.leadSinger;
    data['backingVocals'] = _(this.backingVocals);
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

  _(String txt) {
    return txt.replaceAll(',', '/').replaceAll(' ', '');
  }

  @override
  String toString() {
    return 'Schedule, ${this.leadSinger ?? ''}, ${this.backingVocals ?? ''}, ${this.keyboard ?? ''}, ${this.acoustGuitar ?? ''}, ${this.guitar ?? ''}, ${this.bass ?? ''}, ${this.drums ?? ''}, ${this.backupMusician ?? ''}, ${this.backupVocal ?? ''}';
  }
}
