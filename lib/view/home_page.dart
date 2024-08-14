import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:totalx/model/user_model.dart';
import 'package:totalx/service/add_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    AddService service = AddService();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 177, 177, 177),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            AddBoxDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorRadius: Radius.circular(20),
                      onChanged: (value) {
                        setState(() {
                          searchQuery =
                              value.toLowerCase(); // Update search query
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Users List",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder<QuerySnapshot<UserModel>>(
                stream: service.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("No users found."),
                    );
                  } else {
                    List<QueryDocumentSnapshot<UserModel>> userDatas =
                        snapshot.data!.docs;

                    // Filter the data based on search query
                    List<QueryDocumentSnapshot<UserModel>> filteredUserDatas =
                        userDatas
                            .where((user) => user
                                .data()
                                .name!
                                .toLowerCase()
                                .contains(searchQuery))
                            .toList();

                    return ListView.builder(
                      itemCount: filteredUserDatas.length,
                      itemBuilder: (context, index) {
                        final data = filteredUserDatas[index].data();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            visualDensity: VisualDensity(
                              vertical: BorderSide.strokeAlignInside,
                            ),
                            tileColor: Colors.white,
                            leading: CircleAvatar(
                              maxRadius: 30,
                              child: Icon(Icons.person),
                            ),
                            title: Text(data.name.toString()),
                            subtitle: Text('Age: ${data.age},'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> AddBoxDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  maxRadius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                Gap(16),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                Gap(16),
                TextFormField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text("Age"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                Gap(16),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    label: Text("Phone"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                clearControllers();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty &&
                    ageCtrl.text.isNotEmpty &&
                    phoneCtrl.text.isNotEmpty) {
                  addData(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  addData(BuildContext context) async {
    AddService service = AddService();
    final datas = UserModel(
      name: nameCtrl.text,
      age: int.tryParse(ageCtrl.text),
      phone: phoneCtrl.text,
      image: "",
    );

    await service.addData(datas);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User added successfully')),
    );

    Navigator.of(context).pop();
    clearControllers();
  }

  void clearControllers() {
    nameCtrl.clear();
    ageCtrl.clear();
    phoneCtrl.clear();
  }
}
