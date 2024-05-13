import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../functions/db_functions.dart';
import 'details_screen.dart';
import 'edit_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final myStudent = Get.put(
    StudentController(),
  );

  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    myStudent.setSearchList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Search'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Column(
          children: [
            CupertinoSearchTextField(
              onChanged: (value) {
                myStudent.search(
                  value.trim(),
                );
                // searchQuery.value = value;
              },
            ),
            Expanded(
              child: Obx(() {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final data = myStudent.searchStudentList[index];
                    if (data.name.toLowerCase().contains(
                          searchQuery.value.toLowerCase(),
                        )) {
                      return ListTile(
                        onTap: () {
                          Get.to(
                            ScreenDetails(
                                imagePath: data.imgpath,
                                name: data.name,
                                age: data.age,
                                subject: data.subject,
                                phone: data.phone),
                          );
                        },
                        // leading: const CircleAvatar(),
                        leading: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: SizedBox(
                              width: 58,
                              height: 100,
                              child: (data.imgpath != '')
                                  ? Image.file(
                                      File(data.imgpath),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/profile.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        title: Text(
                          data.name,
                        ),
                        subtitle: Text(
                          data.age,
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(
                                    () => EditScreen(
                                      name: data.name,
                                      age: data.age,
                                      subject: data.subject,
                                      phone: data.phone,
                                      id: data.key,
                                      imagepath: data.imgpath,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                                color: Colors.green,
                              ),
                              IconButton(
                                onPressed: () {
                                  myStudent.deleteStudent(data.key);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: myStudent.searchStudentList.length,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
