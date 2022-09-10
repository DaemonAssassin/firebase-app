import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/post/post_screen.dart';
import '../screens/auth/login_screen.dart';

class SplashScreenService {
  void isLogin(BuildContext context) {
    print('callingGGGGGGGGg');
    FirebaseAuth auth = FirebaseAuth.instance;
    print('calling1');
    User? user = auth.currentUser;
    print('calling2');

    if (user == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LoginScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const PostScreen())));
    }
  }
}
