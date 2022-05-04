part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchResult extends SearchState {
  final List<student> studentList;
  SearchResult({required this.studentList});
}
