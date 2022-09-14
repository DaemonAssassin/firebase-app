import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/helper_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _resetEmailController;
  late FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    _resetEmailController = TextEditingController();
    _firebaseAuth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  void dispose() {
    _resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _resetEmailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Email',
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _firebaseAuth.sendPasswordResetEmail(
                email: _resetEmailController.text);
            HelperWidgets.showToast('Email Sent To Reset Password');
          } catch (e) {
            HelperWidgets.showToast(e.toString());
          }
        },
        child: const Icon(Icons.lock_reset),
      ),
    );
  }
}
