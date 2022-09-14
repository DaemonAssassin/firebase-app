// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/auth/login_screen.dart';
import 'package:flutter_firebase/screens/widgets/round_button.dart';
import 'package:flutter_firebase/utils/helper_widgets.dart';

import 'add_data_to_firestore_screen.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  late FirebaseAuth _firebaseAuth;

  late TextEditingController _updateController;
  late final CollectionReference<Map<String, dynamic>> _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = FirebaseFirestore.instance.collection('User');
    _firebaseAuth = FirebaseAuth.instance;
    _updateController = TextEditingController();
    _firebaseAuth.authStateChanges().listen((User? user) {
      user == null ? print('signedOut') : print('SignIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase List Screen'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _collectionReference.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        String id = snapshot.data!.docs[index]['id'].toString();
                        String name =
                            snapshot.data!.docs[index]['name'].toString();
                        return ListTile(
                          title: Text(id),
                          subtitle: Text(name),
                          trailing: PopupMenuButton(
                            child: const Icon(Icons.more_vert),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(Icons.update),
                                  title: const Text('Update'),
                                  onTap: () async {
                                    await showUpdateDialog(
                                      name,
                                      id,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                    onTap: () async {
                                      await showDeleteDialog(id);
                                      Navigator.pop(context);
                                    }),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            RoundButton(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const AddDataToFirestoreScreen(),
                ));
              },
              title: 'Add Data To Firestore',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateDialog(String name, String id) async {
    _updateController.text = name;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _updateController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Update value';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _collectionReference
                      .doc(id)
                      .update({'name': _updateController.text});
                  HelperWidgets.showToast('Updated');
                } catch (e) {
                  HelperWidgets.showToast(e.toString());
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteDialog(String id) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Do you really want to delete?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No')),
            TextButton(
                onPressed: () async {
                  try {
                    await _collectionReference.doc(id).delete();
                    HelperWidgets.showToast('Deleted Successfully');
                  } catch (e) {
                    HelperWidgets.showToast(e.toString());
                  }
                  Navigator.pop(context);
                },
                child: const Text('Yes')),
          ],
        );
      },
    );
  }
}
