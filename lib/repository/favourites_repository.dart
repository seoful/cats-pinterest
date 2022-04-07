import 'dart:async';
import 'dart:convert';
import 'package:cats/model/giphy_objects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';

typedef CollectionsMap = Map<String, List<GifBundle>>;

class FavouritesRepository {
  FavouritesRepository() {
    _openBoxAndLoad();
  }

  static const defaultCollectionName = "default";

  static const favouritesBoxName = "favourites";

  final isLoaded = BehaviorSubject<bool>.seeded(false);

  late Box<List<String>> box;

  final _gifs = BehaviorSubject<CollectionsMap>();

  Stream<CollectionsMap> get stream => _gifs.stream;

  final _lock = Lock();

  Future<void> _openBoxAndLoad() async {
    box = await Hive.openBox(favouritesBoxName);
    _gifs.add(_getCollectionsFromBox());
    _gifs.listen((value) {
      _saveChanges(value);
    });
    isLoaded.add(true);
  }

  CollectionsMap _getCollectionsFromBox() {
    final map = box.toMap().map((name, jsonList) => MapEntry(name as String,
        jsonList.map((json) => GifBundle.fromJson(jsonDecode(json))).toList()));
    if (!map.containsKey(defaultCollectionName)) {
      map.addEntries([const MapEntry(defaultCollectionName, [])]);
    }
    return map;
  }

  void _saveChanges(CollectionsMap collections) {
    box.putAll(collections.map((name, gifs) =>
        MapEntry(name, gifs.map((gif) => jsonEncode(gif.toJson())).toList())));
  }

  Future<void> addToFavourites(GifBundle gif,
      {String collectionName = defaultCollectionName}) async {
    await _lock.synchronized(() async {
      await isLoaded.firstWhere((element) => element);
      gif = gif.copyWith(addTime: DateTime.now());
      _addToFavourites(gif, collectionName);
    });
  }

  void _addToFavourites(GifBundle gif, String collectionName) {
    final map = CollectionsMap.from(_gifs.valueOrNull!);
    if (map.containsKey(collectionName)) {
      map.update(collectionName, (value) => [...value, gif]);
    } else {
      map.addEntries([
        MapEntry(collectionName, [gif])
      ]);
    }
    _gifs.add(map);
  }

  Future<void> deleteFromFavourites(
      GifBundle gif, String collectionName) async {
    await _lock.synchronized(() async {
      await isLoaded.firstWhere((element) => element);
      gif = gif.copyWith(addTime: DateTime.now());
      _deleteFromFavourites(gif, collectionName);
    });
  }

  void _deleteFromFavourites(GifBundle gif, String collectionName) {
    final map = CollectionsMap.from(_gifs.valueOrNull!);
    map[collectionName]!.removeWhere((element) => element.id == gif.id);
    _gifs.add(map);
  }

  List<String> find(String id) {
    final list = <String>[];
    final map = _gifs.valueOrNull!;
    map.forEach((name, gifList) {
      if (gifList.indexWhere((gif) => gif.id == id) != -1) list.add(name);
    });

    return list;
  }

  Future<bool> createCollection(String name) async {
    var nameExists = false;

    await _lock.synchronized(() async {
      await isLoaded.firstWhere((element) => element);
      final map = _gifs.valueOrNull!;

      if (map.containsKey(name)) {
        nameExists = true;
      } else {
        map.addEntries([MapEntry(name, [])]);
        _gifs.add(map);
      }
    });
    return nameExists;
  }

  Future<void> deleteCollection(String name) async {
    await _lock.synchronized(() async {
      await isLoaded.firstWhere((element) => element);
      final map = CollectionsMap.from(_gifs.valueOrNull!);
      map.remove(name);
      _gifs.add(map);
    });
  }
}
