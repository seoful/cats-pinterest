part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesNotInitialized extends FavouritesState {}

class FavouritesUpdated extends FavouritesState {
  final List<CollectionItem> collections;

  FavouritesUpdated(this.collections);
}

class CreatingCollection extends FavouritesState {}

class CollectionCreated extends FavouritesState {}

class CollectionAlreadyExists extends FavouritesState {}

class DeletingCollection extends FavouritesState {}

class CollectionDeleted extends FavouritesState{}
