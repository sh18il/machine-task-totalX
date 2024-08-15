import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/service_controller.dart';

//filtter ckeckBox
Future<dynamic> filtterBoxSeet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Consumer<ServiceController>(
        builder: (context, provider, _) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: CircleBorder(),
                                side:
                                    BorderSide(width: 1.5, color: Colors.black),
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue;
                                  }
                                  return Colors.transparent;
                                }),
                                checkColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                            ),
                            child: Checkbox(
                              value: !provider.filterElder &&
                                  !provider.filterYounger,
                              onChanged: (value) {
                                provider.resetFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("All"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: CircleBorder(),
                                side:
                                    BorderSide(width: 1.5, color: Colors.black),
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue;
                                  }
                                  return Colors.transparent;
                                }),
                                checkColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                            ),
                            child: Checkbox(
                              value: provider.filterElder,
                              onChanged: (value) {
                                provider.setFilterElder(value ?? false);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("Age: Elder"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                shape: CircleBorder(),
                                side:
                                    BorderSide(width: 1.5, color: Colors.black),
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.blue;
                                  }
                                  return Colors.transparent;
                                }),
                                checkColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                            ),
                            child: Checkbox(
                              value: provider.filterYounger,
                              onChanged: (value) {
                                provider.setFilterYounger(value ?? false);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("Age: Younger"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

//add dialogBox
Future<dynamic> addBoxDialog(BuildContext context) {
  final provider = Provider.of<ServiceController>(context, listen: false);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<ServiceController>(builder: (context, pro, _) {
                return FutureBuilder<File?>(
                  future: Future.value(pro.pickedImage),
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () => provider.pickImg(),
                      child: CircleAvatar(
                        backgroundImage: snapshot.data != null
                            ? FileImage(snapshot.data!)
                            : null,
                        child: snapshot.data == null
                            ? Image(
                                image:
                                    AssetImage("assets/images/Group 18797.png"))
                            : null,
                        maxRadius: 40,
                      ),
                    );
                  },
                );
              }),
              Gap(16),
              TextFormField(
                controller: provider.nameCtrl,
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
                controller: provider.ageCtrl,
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
                controller: provider.phoneCtrl,
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.clearControllers();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () {
              if (provider.nameCtrl.text.isNotEmpty &&
                  provider.ageCtrl.text.isNotEmpty &&
                  provider.phoneCtrl.text.isNotEmpty) {
                provider.addData(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
