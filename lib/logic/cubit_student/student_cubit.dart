import 'dart:async';
// import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:project/logic/bloc/search_bloc.dart';
import 'package:project/model/student_model.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final List<student> listofstudents;
  final SearchBloc searchBloc;
  late StreamSubscription subscription;

  StudentCubit({
    required this.listofstudents,
    required this.searchBloc,
  }) : super(StudentState(list: listofstudents)) {
    emit(AllStudentState(studentsList: listofstudents));
    subscription = searchBloc.stream.listen((state) {
      if (state is SearchResult) {
        studentlistUpdated(state.studentList);
      } else {
        emit(AllStudentState(studentsList: listofstudents));
      }
    });
  }

  void studentlistUpdated(List<student> list) {
    emit(AllStudentState(studentsList: list));
  }

  // void addstudentlist(Box<student>box, student students){
  //       Hive.box<student>("student_db").add(students);
  //       emit(AllStudentState(studentsList: box.values.toList()));


  // }

  String imageAdd(String imageurl) {
    emit(StudentState(
        imageUrl: imageurl,
        list: Hive.box<student>("student_db").values.toList()));
        return state.imageUrl!;
  }
  
  List<student> allStudents(List<student> list) {
    emit(AllStudentState(studentsList: list));
    return state.list;
  }

  delete(int key) {
    Hive.box<student>("student_db").delete(key);
  }
  
  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

}
