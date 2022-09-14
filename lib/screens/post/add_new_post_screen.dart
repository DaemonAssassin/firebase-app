import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/helper_widgets.dart';
import '../widgets/round_button.dart';

class AddNewPostScreen extends StatefulWidget {
  const AddNewPostScreen({Key? key}) : super(key: key);

  @override
  State<AddNewPostScreen> createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  late TextEditingController _postController;
  late final DatabaseReference _firebaseDBRef =
      FirebaseDatabase.instance.ref('Truck');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
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
        title: const Text('Add New Post'),
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
                  await _firebaseDBRef.child(id).set(
                    {'id': id, 'title': _postController.text},
                  );

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
