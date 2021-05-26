import 'package:louvor_bethel/src/models/lyric_model.dart';

abstract class ILyricRepository {
  void get();
  Future save(LyricModel model);
  Future delete(LyricModel model);
}
