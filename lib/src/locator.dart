import 'package:get_it/get_it.dart';
import 'package:louvor_bethel/src/models/auth_model.dart';
import 'package:louvor_bethel/src/models/auth_state_model.dart';
import 'package:louvor_bethel/src/models/base_model.dart';

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => BaseModel());
  locator.registerLazySingleton(() => AuthModel());
  locator.registerLazySingleton(() => AuthStateModel());
}
