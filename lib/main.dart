import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project/logic/bloc/search_bloc.dart';
import 'package:project/logic/cubit_icon/icon_cubit.dart';
import 'package:project/logic/cubit_student/student_cubit.dart';
import 'package:project/model/student_model.dart';
import 'package:project/screeen/home_Screen.dart';
// import 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(studentAdapter());
  await Hive.openBox<student>('student_db');
  runApp(MyApp(
    searchBloc: SearchBloc(),
  ));
}

class MyApp extends StatelessWidget {
  final SearchBloc searchBloc;
  const MyApp({Key? key, required this.searchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StudentCubit(
            listofstudents: Hive.box<student>("student_db").values.toList(),
            searchBloc: searchBloc,
          ),
        ),
        BlocProvider(
          create: (context) => searchBloc,

        ),
        BlocProvider(
          create: (context) => IconCubit()
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
