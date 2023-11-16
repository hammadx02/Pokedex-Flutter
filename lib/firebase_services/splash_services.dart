import 'dart:async';


import 'package:flutter/material.dart';



class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const HomeScreen()),
          ),
        );
      },);
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const LoginScreen()),
          ),
        );
      },);
    }
  }
}
