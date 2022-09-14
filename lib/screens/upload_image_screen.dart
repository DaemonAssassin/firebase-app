// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/helper_widgets.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _imageFile;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late Widget _widget;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    getWidget();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image Screen'),
      ),
      body: InkWell(
        onTap: pickImageFromGallery,
        child: Center(
          child: _widget,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await uploadImageAndGetUrl();
        },
        child: const Icon(Icons.upload),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      HelperWidgets.showToast('Image not Selected.');
    } else {
      HelperWidgets.showToast('Image Selected Successfully.');
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Future<void> uploadImageAndGetUrl() async {
    setState(() {
      isLoading = true;
    });
    Reference reference = _firebaseStorage
        .ref('/images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = reference.putFile(_imageFile!);

    await Future.value(uploadTask);

    String url = await reference.getDownloadURL();
    try {
      await _firebaseDatabase
          .ref('Truck')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'title': url,
        'id': DateTime.now().millisecondsSinceEpoch.toString()
      });
      HelperWidgets.showToast('Done');
    } catch (e) {
      HelperWidgets.showToast(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void getWidget() {
    if (_imageFile == null && isLoading == false) {
      _widget = Container(
        decoration: BoxDecoration(border: Border.all()),
        width: 300.0,
        height: 300.0,
        child: const Center(
          child: Icon(Icons.image),
        ),
      );
    } else if (_imageFile != null && isLoading == false) {
      _widget = Image.file(
        _imageFile!,
        width: 300.0,
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      _widget = const CircularProgressIndicator();
    }
  }
}
