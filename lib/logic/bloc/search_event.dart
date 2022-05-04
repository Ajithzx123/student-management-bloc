part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {
  const SearchEvent();
}

class EnterInputEvent extends SearchEvent {
  final String searchInput;
  const EnterInputEvent({required this.searchInput});
}


class ClearInputEvent extends SearchEvent {}
