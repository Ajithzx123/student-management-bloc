import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/logic/cubit_student/student_cubit.dart';
import 'package:project/model/student_model.dart';

class edit_details extends StatefulWidget {
  var box = Hive.box<student>('student_db');
  final List<student> obj;
  final int index;
  edit_details({Key? key, required this.obj, required this.index})
      : super(key: key);

  @override
  _edit_detailsState createState() => _edit_detailsState();
}

class _edit_detailsState extends State<edit_details> {
  TextEditingController NameText = TextEditingController();
  TextEditingController AgeText = TextEditingController();
  TextEditingController PlaceText = TextEditingController();

  XFile? image;
  String? imagepath;

  void auotofill() {
    NameText.text = widget.obj[widget.index].name;
    PlaceText.text = widget.obj[widget.index].place;
    AgeText.text = widget.obj[widget.index].age.toString();
    imagepath = widget.obj[widget.index].imagepath;
  }

  @override
  void initState() {
    auotofill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        title: Text('Edit ${widget.obj[widget.index].name}'),
      ),
      body: Form(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
                style: const TextStyle(fontSize: 16),
                controller: NameText,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    labelText: ' Enter your Name',
                    suffixIcon: Icon(Icons.person))),
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
                    suffixIcon: Icon(Icons.add))),
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
                                onPressed: () {
                                  Getimage(source: ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                child: const Text('choose Image ')),
                            TextButton(
                                onPressed: () {
                                  Getimage(source: ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                child: Text('Take a Image '))
                          ],
                        );
                      });
                },
                child: Text('Upload  New Image')),
            ElevatedButton(
                onPressed: () {
                  widget.box.putAt(
                      widget.index,
                      student(
                          imagepath: imagepath,
                          name: NameText.text,
                          age: int.parse(AgeText.text),
                          place: PlaceText.text));
                  Navigator.pop(context);
                  BlocProvider.of<StudentCubit>(context).studentlistUpdated(
                      Hive.box<student>("student_db").values.toList());
                },
                child: Text('UPDATE'))
          ],
        ),
      )),
    );
  }

  Getimage({required ImageSource source}) async {
    image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      imagepath = context.read<StudentCubit>().imageAdd(image!.path);
    } else {
      return null;
    }
  }
}
