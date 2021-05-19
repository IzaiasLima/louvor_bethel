import 'package:get_it/get_it.dart';

import 'models/auth_model.dart';
import 'models/auth_state_model.dart';
import 'models/base_model.dart';

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => BaseModel());
  locator.registerLazySingleton(() => AuthModel());
  locator.registerLazySingleton(() => AuthStateModel());
}
