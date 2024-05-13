import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:students_data/models/model.dart';
import 'package:students_data/screens/add_student.dart';
import 'package:students_data/screens/details_screen.dart';
import 'package:students_data/screens/edit_screen.dart';
import 'package:students_data/screens/search_screen.dart';
import '../functions/db_functions.dart';

// ignore: must_be_immutable
class ScreenHome extends StatelessWidget {
  final StudentController myStudent = Get.put(
    StudentController(),
  );

  ScreenHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    myStudent.getAllStudents();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Student List'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => SearchScreen(),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Obx(
        () {
          final studentList = myStudent.studentList;
          return ListView.builder(
            itemCount: myStudent.studentList.length,
            itemBuilder: ((context, index) {
              final data = studentList[index];
              return ListTile(
                onTap: () {
                  Get.to(
                    () => ScreenDetails(
                        imagePath: data.imgpath,    
                        name: data.name,
                        age: data.age,
                        subject: data.subject,
                        phone: data.phone),
                  );
                },
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
                title: Text(data.name),
                subtitle: Text(data.age),
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
                              id: data.key ?? '',
                              imagepath: data.imgpath,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, data);
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(
            () => ScreenAddStudent(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, StudentModel data) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${data.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              myStudent.deleteStudent(data.key);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
