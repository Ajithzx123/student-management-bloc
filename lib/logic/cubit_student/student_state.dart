part of 'student_cubit.dart';

@immutable
 class StudentState {
  final String? imageUrl;
  final List<student> list;
  const StudentState({this.imageUrl, required this.list});
}

class AllStudentState extends StudentState {
  final List<student> studentsList;
  const AllStudentState({required this.studentsList})
      : super(list: studentsList);
}

class NoResultState extends StudentState {
  NoResultState({List<student>? list}) : super(list: []);
}