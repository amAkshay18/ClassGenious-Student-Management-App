import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_data/models/model.dart';
import '../functions/db_functions.dart';

// ignore: must_be_immutable
class EditScreen extends StatelessWidget {
  final int id;
  String name;
  String age;
  String subject;
  String phone;
  String imagepath;

  EditScreen({
    super.key,
    required this.name,
    required this.age,
    required this.subject,
    required this.phone,
    required this.id,
    required this.imagepath,
  });

  final myStudent = Get.put(StudentController());
  File? selectedimage;

  // ignore: non_constant_identifier_names
  final student_nameEdit = TextEditingController();

// ignore: non_constant_identifier_names
  final student_ageEdit = TextEditingController();

// ignore: non_constant_identifier_names
  final student_subjectEdit = TextEditingController();

// ignore: non_constant_identifier_names
  final student_phoneNumberEdit = TextEditingController();
  final studentController = Get.put(
    StudentController(),
  );
  @override
  Widget build(BuildContext context) {
    student_nameEdit.text = name;
    student_ageEdit.text = age;
    student_subjectEdit.text = subject;
    student_phoneNumberEdit.text = phone;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Edit'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        // ignore: unused_local_variable
                        selectedimage = await getImage();
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.transparent,
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(40),
                          child: ClipOval(
                            child: Obx(() {
                              File img =
                                  File(studentController.imagePath.value);
                              if (studentController.isPicked.value == true &&
                                  studentController.imagePath.value != '') {
                                return Image.file(
                                  img,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              } else if (imagepath != '') {
                                return Image.file(
                                  File(imagepath),
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
                            }),
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
                  controller: student_nameEdit,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: student_ageEdit,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Age'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: student_subjectEdit,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Subject'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: student_phoneNumberEdit,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Phone Number'),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  final data = StudentModel(
                      name: student_nameEdit.text,
                      age: student_ageEdit.text,
                      subject: student_subjectEdit.text,
                      phone: student_phoneNumberEdit.text,
                      imgpath: (studentController.isPicked.value == true &&
                              studentController.imagePath.value != '')
                          ? selectedimage!.path
                          : imagepath);
                  myStudent.editStudent(id, data);
                  Get.back();
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> getImage() async {
    XFile? image;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return File(imagepath);
    }
    // ignore: unused_local_variable
    studentController.setPickedImage(image.path, true);
    final imageTemporary = File(image.path);
    return imageTemporary;
  }
}
