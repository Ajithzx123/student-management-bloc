import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/logic/cubit_student/student_cubit.dart';
import 'package:project/model/student_model.dart';
import 'dart:io';

class Add_details extends StatelessWidget {
  Add_details({Key? key}) : super(key: key);

  var box = Hive.box<student>('student_db');
  final TextEditingController NameText = TextEditingController();
  final TextEditingController AgeText = TextEditingController();
  final TextEditingController PlaceText = TextEditingController();

  XFile? image;
  String? imagepath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: const Text('Add Detials'),
      ),
      body: Form(child: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                TextField(
                    style: const TextStyle(fontSize: 16),
                    controller: NameText,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      labelText: ' Enter your Name',
                      suffixIcon: Icon(Icons.person),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: AgeText,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      labelText: 'Enter your Age',
                      suffixIcon: Icon(Icons.add),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: PlaceText,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      labelText: ' Enter your Place',
                      suffixIcon: Icon(Icons.place)),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<StudentCubit, StudentState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        if (imagepath != null)
                          ClipRRect(
                            child: Image.file(
                              File(imagepath!),
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('choose any option'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      // Getimage(source: ImageSource.gallery);
                                      image = await ImagePicker().pickImage(
                                          source: ImageSource.gallery);

                                      if (image != null) {
                                        imagepath = context
                                            .read<StudentCubit>()
                                            .imageAdd(image!.path);
                                      } else {
                                        return null;
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text('choose Image ')),
                                TextButton(
                                    onPressed: () async {
                                      // Getimage(source: ImageSource.camera);
                                      image = await ImagePicker().pickImage(
                                          source: ImageSource.camera);

                                          if (image != null) {
                                        imagepath = context
                                            .read<StudentCubit>()
                                            .imageAdd(image!.path);
                                          }


                                      Navigator.pop(context);
                                      
                                    },
                                    child: Text('Take a Image '))
                              ],
                            );
                          });
                    },
                    child: Text('Upload Image')),
                ElevatedButton(
                    onPressed: () {
                      box.add(student(
                          imagepath: imagepath,
                          name: NameText.text,
                          age: int.parse(AgeText.text),
                          place: PlaceText.text));
                      BlocProvider.of<StudentCubit>(context)
                          .allStudents(box.values.toList());

                      Navigator.pop(context);
                    },
                    child: Text('SAVE'))
              ],
            ),
          );
        },
      )),
    );
  }

  Getimage({required ImageSource source}) async {
    // image = await ImagePicker().pickImage(source: source);
    // if (image != null) {
    //   setState(() {
    //     imagepath = (image!.path);
    //   });
    // } else {
    //   return null;
    // }
    // imagepath = context.read<StudentCubit>().imageAdd(image!.path);
  }
}
