import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:project/model/student_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchResult(studentList: Hive.box<student>("student_db").values.toList())) {
    on<SearchEvent>((event, emit) {

      if (event is EnterInputEvent) {
        List<student> newListofStudents = Hive.box<student>("student_db")
            .values
            .toList()
            .where((element) =>
                element.name.toLowerCase().contains(event.searchInput.toLowerCase()))
            .toList();
        emit(SearchResult(studentList: newListofStudents));
      } else if (event is ClearInputEvent) {
        emit(SearchResult(
            studentList: Hive.box<student>("student_db").values.toList()));
      }


    });
  }
}
