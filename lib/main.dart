import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:louvor_bethel/src/my_app.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
