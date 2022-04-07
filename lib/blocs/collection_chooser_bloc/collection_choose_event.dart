part of 'collection_choose_bloc.dart';

@immutable
abstract class CollectionChooseEvent {}

class LoadOrRefreshChooseData extends CollectionChooseEvent {}

class AddToCollection extends CollectionChooseEvent {
  final String collectionName;

  AddToCollection(this.collectionName);
}

class RemoveFromCollection extends CollectionChooseEvent {
  final String collectionName;

  RemoveFromCollection(this.collectionName);
}

