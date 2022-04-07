import 'package:cats/model/giphy_objects.dart';

class CollectionChooseItem {
  final String name;
  final Gif? collectionGif;
  final GifCollectionStatus gifCollectionStatus;

  CollectionChooseItem(
      this.name, this.collectionGif, this.gifCollectionStatus);

  CollectionChooseItem copyWith(
      {String? name,
      Gif? collectionGif,
      GifCollectionStatus? gifCollectionStatus}) {
    return CollectionChooseItem(
        name ?? this.name,
        collectionGif ?? this.collectionGif,
        gifCollectionStatus ?? this.gifCollectionStatus);
  }
}

enum GifCollectionStatus { included, notIncluded, inProgress }

class CollectionItem{
  final String name;
  final List<GifBundle> gifBundles;

  CollectionItem(this.name, this.gifBundles);
}
