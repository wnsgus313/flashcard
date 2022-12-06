import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // flutter 비동기 실행
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(
    const MyApp(),
  );
}
