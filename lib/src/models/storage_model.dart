import 'package:louvor_bethel/src/locator.dart';
import 'package:louvor_bethel/src/models/base_model.dart';
import 'package:louvor_bethel/src/services/api.dart';

class StorageModel extends BaseModel {
  final api = locator<Api>();
  var db;

  StorageModel(String dbName) {
    api.setDBName(dbName);
    db = api.db;
  }

  getDoc() {
    return;
  }
}
