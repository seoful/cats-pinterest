part of 'search_bloc.dart';

@immutable
abstract class SearchBlocEvent {}

class SearchMoreGifs extends SearchBlocEvent {
  final String query;

  SearchMoreGifs([String? query]) : query = query ?? "";
}
