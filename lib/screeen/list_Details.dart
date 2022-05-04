import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/model/student_model.dart';

class list_view extends StatelessWidget {
  var box = Hive.box<student>('student_db');
  
  final int index;
  
  list_view({Key? key,  required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var listdb = box.values.toList();
    final newkey = box.get(index);
    return Scaffold(
      appBar: AppBar(
        title: Text(newkey!.name),
        centerTitle: true,
        elevation: 10,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRect(
              child: newkey.imagepath == null
                  ? null
                  : ClipRect(
                      child: Image.file(
                        File(newkey.imagepath),
                        width: 350,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newkey.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 55,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newkey.place,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 35,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ('${newkey.age}'),
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
