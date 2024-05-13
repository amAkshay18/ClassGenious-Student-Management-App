import 'dart:io';
import 'package:flutter/material.dart';

class ScreenDetails extends StatelessWidget {
  final String name;
  final String age;
  final String subject;
  final String phone;
  final String imagePath;

  ScreenDetails({
    Key? key,
    required this.name,
    required this.age,
    required this.subject,
    required this.phone,
    this.imagePath = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: Image.file(
                  File(imagePath),
                ).image,
              ),
            const SizedBox(
              height: 20,
            ),
            Text(name),
            const SizedBox(
              height: 20,
            ),
            Text(age),
            const SizedBox(
              height: 20,
            ),
            Text(subject),
            const SizedBox(
              height: 20,
            ),
            Text(phone),
          ],
        ),
      ),
    );
  }
}
