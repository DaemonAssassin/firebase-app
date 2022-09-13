// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/screens/post/post_screen.dart';

import '../../utils/helper_widgets.dart';
import '../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  final String verificationId;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _verificationCodeController;
  late final FirebaseAuth _firebaseAuth;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _verificationCodeController = TextEditingController();
    _firebaseAuth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
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
          title: const Text('Verify Code'),
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
                    controller: _verificationCodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '6 Digit Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length != 6) {
                        return 'Enter Valid Code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50.0),
                  RoundButton(
                      isLoading: isLoading,
                      onTap: () {
                        bool isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          verifyCode();
                        }
                      },
                      title: 'Verify'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void verifyCode() async {
    try {
      setState(() => isLoading = true);
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _verificationCodeController.text,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        HelperWidgets.showToast('Login Successful');

        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PostScreen(),
        ));
      } else {
        HelperWidgets.showToast('Something went wrong');
        Navigator.pop(context);
      }
    } catch (e) {
      HelperWidgets.showToast(e.toString());
    }
    setState(() => isLoading = false);
  }
}
