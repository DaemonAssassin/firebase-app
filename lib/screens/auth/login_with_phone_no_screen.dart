// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/helper_widgets.dart';
import '../widgets/round_button.dart';
import 'verify_code_screen.dart';

class LoginWithPhoneNoScreen extends StatefulWidget {
  const LoginWithPhoneNoScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNoScreen> createState() => _LoginWithPhoneNoScreenState();
}

class _LoginWithPhoneNoScreenState extends State<LoginWithPhoneNoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneNoController;
  late final FirebaseAuth _firebaseAuth;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneNoController = TextEditingController();
    _firebaseAuth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login With Phone No Screen'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _phoneNoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '+92 346 7560225',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Valid Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 50.0),
                  RoundButton(
                      isLoading: isLoading,
                      onTap: () {
                        bool isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          sendCode();
                        }
                      },
                      title: 'Send'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendCode() async {
    try {
      setState(() => isLoading = true);

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNoController.text,
        verificationCompleted: (_) {},
        verificationFailed: (error) =>
            HelperWidgets.showToast(error.toString()),
        codeSent: (verificationId, _) {
          log(verificationId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyCodeScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {
          HelperWidgets.showToast('Timeout');
        },
      );
    } catch (e) {
      HelperWidgets.showToast(e.toString());
    }
    setState(() => isLoading = false);
  }
}
