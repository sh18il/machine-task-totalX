import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totalx/model/user_model.dart';
import 'package:totalx/service/add_service.dart';
import 'package:image_picker/image_picker.dart';

class ServiceController extends ChangeNotifier {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  String searchQuery = '';
  File? pickedImage;

  bool isNewImagePicked = false;
  bool filterElder = false;
  bool filterYounger = false;

  ImagePicker image = ImagePicker();
  AddService service = AddService();

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> pickImgCam() async {
    var img = await image.pickImage(source: ImageSource.camera);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }

  Future<void> addData(BuildContext context) async {
    if (pickedImage != null) {
      String? imageUrl = await service.addImage(pickedImage!, context);

      final userData = UserModel(
        name: nameCtrl.text,
        age: int.tryParse(ageCtrl.text),
        phone: phoneCtrl.text,
        image: imageUrl ?? "",
      );

      await service.addData(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully')),
      );

      Navigator.of(context).pop();
      clearControllers();
      clearPickedImage();
    } else {
      final userData = UserModel(
        name: nameCtrl.text,
        age: int.tryParse(ageCtrl.text),
        phone: phoneCtrl.text,
        image: "",
      );

      await service.addData(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User added successfully without an image')),
      );

      Navigator.of(context).pop();
      clearControllers();
    }
  }

  Stream<QuerySnapshot<UserModel>> getUser() {
    return service.getData();
  }

  void clearControllers() {
    nameCtrl.clear();
    ageCtrl.clear();
    phoneCtrl.clear();
  }

  void searchStatus(String value) {
    searchQuery = value.toLowerCase();
    notifyListeners();
  }

  // Filter
  void setFilterElder(bool value) {
    filterElder = value;
    if (value) filterYounger = false;
    notifyListeners();
  }

  void setFilterYounger(bool value) {
    filterYounger = value;
    if (value) filterElder = false;
    notifyListeners();
  }

  void resetFilters() {
    filterElder = false;
    filterYounger = false;
    notifyListeners();
  }

  List<QueryDocumentSnapshot<UserModel>> applyFilters(
    List<QueryDocumentSnapshot<UserModel>> userDatas,
  ) {
    return userDatas.where((user) {
      final name = user.data().name?.toLowerCase() ?? '';
      final age = user.data().age ?? 0;

      final matchesSearch = name.contains(searchQuery);
      final matchesAgeFilter = (filterElder && age >= 60) ||
          (filterYounger && age < 60) ||
          (!filterElder && !filterYounger);

      return matchesSearch && matchesAgeFilter;
    }).toList();
  }
}
