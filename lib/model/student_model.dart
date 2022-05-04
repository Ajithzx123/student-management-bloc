import 'package:hive/hive.dart';
part 'student_model.g.dart';

@HiveType(typeId: 0)
class student extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String place;

  @HiveField(3)
  final dynamic imagepath;

  student(
      {required this.name,
      required this.age,
      required this.place,
      this.imagepath});
}
