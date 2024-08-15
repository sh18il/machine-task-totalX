import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/service_controller.dart';
import 'package:totalx/model/user_model.dart';
import 'package:totalx/view/widget/home_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              Gap(5),
              Text(
                "Nilambur",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 177, 177, 177),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            addBoxDialog(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<ServiceController>(
                      builder: (context, provider, _) {
                        return TextField(
                          cursorRadius: const Radius.circular(20),
                          onChanged: (value) {
                            provider.searchStatus(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search by Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(5),
                  InkWell(
                    onTap: () {
                      filtterBoxSeet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Users Lists",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Consumer<ServiceController>(
                builder: (context, provider, _) {
                  return StreamBuilder<QuerySnapshot<UserModel>>(
                    stream: provider.getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(
                              "assets/lottie/Animation - 1707804128790.json"),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Lottie.asset(
                              "assets/lottie/Animation - 1707804128790.json"),
                        );
                      } else {
                        List<QueryDocumentSnapshot<UserModel>> userDatas =
                            snapshot.data!.docs;
                        List<QueryDocumentSnapshot<UserModel>>
                            filteredUserDatas =
                            provider.applyFilters(userDatas);
                        if (filteredUserDatas.isEmpty) {
                          return Center(
                            child: Lottie.asset(
                                "assets/lottie/Animation - 1723132358628 (1).json"),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredUserDatas.length,
                          itemBuilder: (context, index) {
                            final data = filteredUserDatas[index].data();

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                minTileHeight: 86,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: Colors.white,
                                leading: CircleAvatar(
                                  maxRadius: 60,
                                  backgroundImage: data.image != null
                                      ? NetworkImage(
                                          data.image.toString(),
                                        )
                                      : const AssetImage(
                                              "assets/images/images.png")
                                          as ImageProvider,
                                  child: data.image == null
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                title: Text(data.name ?? ''),
                                subtitle: Text('Age: ${data.age}'),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
