import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // ignore: prefer_const_constructors
    options: FirebaseOptions(
      apiKey: "AIzaSyDXoJ-w6N9jBtwXY-L2V9hguxwfmdKt75Q",
      appId: "1:332467097313:android:ae37269f1b286f4e3371a0",
      messagingSenderId: "332467097313",
      projectId: "pokedex-ce76f",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.yellow,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
