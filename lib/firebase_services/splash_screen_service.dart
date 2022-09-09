import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';

class SplashScreenService {
  void isLogin(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
    );
  }
}
