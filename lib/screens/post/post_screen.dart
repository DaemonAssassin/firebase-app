// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/auth/login_screen.dart';
import 'package:flutter_firebase/screens/post/add_new_post_screen.dart';
import 'package:flutter_firebase/screens/widgets/round_button.dart';
import 'package:flutter_firebase/utils/helper_widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late FirebaseAuth _firebaseAuth;

  late TextEditingController _searchController;
  late TextEditingController _updateController;

  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    _searchController = TextEditingController();
    _updateController = TextEditingController();
    _firebaseAuth.authStateChanges().listen((User? user) {
      user == null ? print('signedOut') : print('SignIn');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(() {}),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Search';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30.0),
            //* using StreamBuilder
            // Expanded(
            //   child: StreamBuilder<DatabaseEvent>(
            //     stream: FirebaseDatabase.instance.ref('Truck').onValue,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         Map<dynamic, dynamic> map =
            //             snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            //         List<dynamic> list = [...map.values.toList()];
            //         print(map);

            //         return ListView.builder(
            //             itemCount: snapshot.data!.snapshot.children.length,
            //             itemBuilder: (context, index) {
            //               return ListTile(
            //                 title: Text(list[index]['title'].toString()),
            //                 subtitle: Text(list[index]['id'].toString()),
            //               );
            //             });
            //       } else {
            //         return const CircularProgressIndicator();
            //       }
            //     },
            //   ),
            // ),
            // //* using FirebaseAnimatedList
            Expanded(
              child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance.ref('Truck'),
                defaultChild: const Center(child: Text('Loading')),
                itemBuilder: (context, snapshot, animation, index) {
                  String title = snapshot.child('title').value.toString();
                  if (_searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('id').value.toString()),
                      subtitle: Text(snapshot.child('title').value.toString()),
                      trailing: PopupMenuButton(
                        child: const Icon(Icons.more_vert),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.update),
                              title: const Text('Update'),
                              onTap: () async {
                                await showUpdateDialog(
                                  title,
                                  snapshot.child('id').value.toString(),
                                );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Delete'),
                              onTap: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (title
                      .trim()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('id').value.toString()),
                      subtitle: Text(snapshot.child('title').value.toString()),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            RoundButton(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const AddNewPostScreen(),
                ));
              },
              title: 'Add New Post',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateDialog(String title, String id) async {
    _updateController.text = title;
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
                  await FirebaseDatabase.instance.ref('Truck').child(id).update(
                    {'title': _updateController.text},
                  );
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
}
