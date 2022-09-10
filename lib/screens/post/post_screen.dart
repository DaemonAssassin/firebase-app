// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/auth/login_screen.dart';
import 'package:flutter_firebase/utils/helper_widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseAuth.authStateChanges().listen((User? user) {
      user == null ? print('signedOut') : print('SignIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostScreen'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await _firebaseAuth.signOut();
                HelperWidgets.showToast('SignOut Successfully');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              } catch (e) {
                HelperWidgets.showToast(e.toString());
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
