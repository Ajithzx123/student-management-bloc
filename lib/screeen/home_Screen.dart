import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project/edit/edit_data.dart';
import 'package:project/logic/bloc/search_bloc.dart';
import 'package:project/logic/cubit_icon/icon_cubit.dart';
import 'package:project/logic/cubit_student/student_cubit.dart';
import 'package:project/model/student_model.dart';
import 'package:project/screeen/Add_Details.dart';
import 'package:project/screeen/list_Details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  IconData? myIcon;

  // Icon myIcon = const Icon(Icons.search);
  Widget myField = const Text('Students List');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: BlocBuilder<IconCubit, IconCubitState>(
          builder: (context, state) {
            myIcon = state.props[0] as IconData;

            return AppBar(
              title: myField,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      context.read<IconCubit>().changeIcon(myIcon!);

                      if (myIcon == Icons.search) {
                        myField = TextField(
                          onChanged: (value) {
                            context
                                .read<SearchBloc>()
                                .add(EnterInputEvent(searchInput: value));
                          },
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: 'Search here',
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        );
                      } else {
                        // setState(() {
                        //   searchInput = '';
                        // });
                        context.read<SearchBloc>().add(ClearInputEvent());

                        myField = const Text('Students list');
                      }
                    },
                    icon: Icon(myIcon)),
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state is AllStudentState) {
            if (state.studentsList.isEmpty) {
              return const Center(
                child: Text("List is empty"),
              );
            } else {
              final List<student> datas = state.studentsList;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    list_view( index: datas[index].key))),
                        tileColor: Color.fromARGB(255, 234, 235, 233),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          datas[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        leading: datas[index].imagepath == null
                            ? CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                radius: 20,
                              )
                            : CircleAvatar(
                                child: ClipOval(
                                  child: Image.file(
                                    File(datas[index].imagepath),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => edit_details(
                                          obj: datas, index: index))),
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 31, 32, 32),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Are you sure? '),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No')),
                                          TextButton(
                                              onPressed: () {
                                                datas[index].delete();
                                                context.read<StudentCubit>().allStudents(Hive.box<student>('student_db').values.toList());
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'))
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )),
                  );
                },
                itemCount: datas.length,
              );
            }
          } else if (state is NoResultState) {
            return const Center(
              child: Text("no result found"),
            );
          } else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Add_details()),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
