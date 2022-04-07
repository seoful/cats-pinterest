part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

class LoadOrRefreshFavouritesData extends FavouritesEvent {}

class CreateCollection extends FavouritesEvent {
  final String name;

  CreateCollection(this.name);
}

class DeleteCollection extends FavouritesEvent {
  final String name;

  DeleteCollection(this.name);
}
