part of 'search_bloc.dart';

@immutable
abstract class SearchBlocState {}

class MainGifScreenInitialLoad extends SearchBlocState {}

class SearchFirstPageLoading extends SearchBlocState {}

class SearchLoadingNextPage extends SearchBlocState {
  final List<GifBundle> gifs;

  SearchLoadingNextPage(this.gifs);
}

class SearchLoaded extends SearchBlocState {
  final List<GifBundle> gifs;

  SearchLoaded(this.gifs);
}

class SearchLoadedNothing extends SearchBlocState {}

class SearchLoadedToEnd extends SearchBlocState {
  final List<GifBundle> gifs;

  SearchLoadedToEnd(this.gifs);
}

abstract class SearchLoadingError extends SearchBlocState {}

class SearchFirstPageLoadingFail extends SearchLoadingError {}

class SearchLoadingNextPageError extends SearchLoadingError {}
