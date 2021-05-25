import 'package:louvor_bethel/src/models/lyric_model.dart';

abstract class ILyricRepository {
  Future<List<Iterable<LyricModel>>> get();
  Future save(LyricModel model);
  Future delete(LyricModel model);
}
