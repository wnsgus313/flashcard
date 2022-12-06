import 'package:flashcard/pages/add_flashcard.dart';
import 'package:flashcard/pages/flashcard.dart';
import 'package:flashcard/pages/home.dart';
import 'package:flashcard/pages/login.dart';
import 'package:flashcard/pages/memorization.dart';
import 'package:flashcard/pages/option.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard',
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF5B836A),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF5B836A) // 앱의// 전체 컬러를 설정
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5B836A),
        ),
        textTheme: const TextTheme(
          // button: TextStyle(
          //   color: Colors.black,
          // ),
        ),
      ),
      routes: {
        '/': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/flashcard': (BuildContext context) => const FlashcardPage(),
        '/addFlashcard': (BuildContext context) => const AddFlashcardPage(),
        '/memorization': (BuildContext context) => const MemorizationPage(),
        '/option': (BuildContext context) => const OptionPage(),
      },
    );
  }
}