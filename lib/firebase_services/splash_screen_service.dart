import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/upload_image_screen.dart';
import '../screens/auth/login_screen.dart';

class SplashScreenService {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LoginScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UploadImageScreen())));
    }
  }
}
