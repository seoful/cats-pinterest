part of 'collection_choose_bloc.dart';

@immutable
abstract class CollectionChooseState {}

class CollectionChooseInitial extends CollectionChooseState {}

class CollectionChooseListUpdate extends CollectionChooseState{
  final List<CollectionChooseItem> collections;

  CollectionChooseListUpdate(this.collections);
}



