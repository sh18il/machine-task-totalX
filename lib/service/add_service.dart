import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:totalx/model/user_model.dart';

class AddService {
  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String collectionRef = "users";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference<UserModel> addUserRef =
      firestore.collection(collectionRef).withConverter<UserModel>(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  Future<String?> addImage(File image, BuildContext context) async {
    String? url;
    Reference imageFolder = firebaseStorage.child("images");
    Reference uploadImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadImage.putFile(image);
      url = await uploadImage.getDownloadURL();
    } catch (e) {
      showErrorMessage(context, 'Failed to upload image: ${e.toString()}');
    }
    return url;
  }

  Future<void> addData(UserModel model) async {
    await addUserRef.add(model);
  }

  Stream<QuerySnapshot<UserModel>> getData() {
    return addUserRef.snapshots();
  }

  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
