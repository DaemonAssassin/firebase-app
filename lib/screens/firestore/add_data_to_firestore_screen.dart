import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/helper_widgets.dart';
import '../widgets/round_button.dart';

class AddDataToFirestoreScreen extends StatefulWidget {
  const AddDataToFirestoreScreen({Key? key}) : super(key: key);

  @override
  State<AddDataToFirestoreScreen> createState() =>
      _AddDataToFirestoreScreenState();
}

class _AddDataToFirestoreScreenState extends State<AddDataToFirestoreScreen> {
  late TextEditingController _postController;
  late final CollectionReference<Map<String, dynamic>> _collectionReference;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
    _collectionReference = FirebaseFirestore.instance.collection('User');
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data To Firestore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _postController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Email';
                }
                return null;
              },
            ),
            RoundButton(
              isLoading: _isLoading,
              onTap: () async {
                setState(() => _isLoading = true);
                try {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  await _collectionReference
                      .doc(id)
                      .set({'id': id, 'name': _postController.text});
                  HelperWidgets.showToast('Data Added');
                } catch (e) {
                  HelperWidgets.showToast(e.toString());
                }
                _postController.clear();
                setState(() => _isLoading = false);
              },
              title: 'Add',
            ),
          ],
        ),
      ),
    );
  }
}
