import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_data/models/model.dart';
import 'package:students_data/screens/home_screen.dart';
import '../functions/db_functions.dart';

// ignore: camel_case_types, must_be_immutable
class ScreenAddStudent extends StatelessWidget {
  ScreenAddStudent({super.key});
  String selectedimage = "";
  // ignore: non_constant_identifier_names
  final student_name = TextEditingController();
// ignore: non_constant_identifier_names
  final student_age = TextEditingController();
// ignore: non_constant_identifier_names
  final student_subject = TextEditingController();
// ignore: non_constant_identifier_names
  final student_phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final studentController = Get.put(
    StudentController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Student Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<StudentController>(
            builder: (controller) => Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            pickImage();
                          },
                          child: CircleAvatar(
                            radius: 50,
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(50),
                              child: ClipOval(
                                child: Obx(
                                  () {
                                    File img =
                                        File(studentController.imagePath.value);
                                    if (studentController.isPicked.value ==
                                            true &&
                                        studentController.imagePath.value !=
                                            '') {
                                      return Image.file(
                                        img,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Image.asset(
                                        'assets/profile.png',
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: student_name,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This needs to be filled';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: student_age,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This needs to be filled';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: student_subject,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Subject'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This needs to be filled';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: student_phoneNumber,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This needs to be filled';
                        } else if (value.length < 10 || value.length > 10) {
                          return 'Invalid entry';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        StudentModel data = StudentModel(
                          imgpath: studentController.imagePath.value,
                          name: student_name.text,
                          age: student_age.text,
                          subject: student_subject.text,
                          phone: student_phoneNumber.text,
                        );
                        StudentController().addStudent(data);
                        studentController.imagePath.value = '';
                        studentController.getAllStudents();
                        Get.to(
                          ScreenHome(),
                        );
                        Get.snackbar('', 'Successfully added ${data.name}',
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                            backgroundColor: Colors.green);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      studentController.setPickedImage(imagePicked.path, true);
      selectedimage = imagePicked.path;
    }
  }
}
