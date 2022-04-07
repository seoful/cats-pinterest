import 'package:bloc/bloc.dart';
import 'package:cats/blocs/favourites_bloc/favourites_bloc.dart';
import 'package:cats/model/collection_item.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/repository/favourites_repository.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';

part 'collection_choose_event.dart';

part 'collection_choose_state.dart';

class CollectionChooseBloc
    extends Bloc<CollectionChooseEvent, CollectionChooseState> {
  final _repository = Injector.appInstance.get<FavouritesRepository>();

  final _favouritesBloc = Injector.appInstance.get<FavouritesBloc>();

  final GifBundle gifBundle;

  late List<CollectionChooseItem> _lastCollectionChooseItemList;

  CollectionChooseBloc(this.gifBundle) : super(CollectionChooseInitial()) {
    on<AddToCollection>((event, emit) async {
      _changeStatusOfCollectionAndEmit(
          emit, event.collectionName, GifCollectionStatus.inProgress);

      await _repository.addToFavourites(gifBundle,
          collectionName: event.collectionName);

      add(LoadOrRefreshChooseData());
    });

    on<RemoveFromCollection>((event, emit) async {
      _changeStatusOfCollectionAndEmit(
          emit, event.collectionName, GifCollectionStatus.inProgress);

      emit(CollectionChooseListUpdate(_lastCollectionChooseItemList));

      await _repository.deleteFromFavourites(gifBundle, event.collectionName);

      add(LoadOrRefreshChooseData());
    });

    on<LoadOrRefreshChooseData>((event, emit) async {
      await _repository.isLoaded.stream.firstWhere((element) => element);

      final map = await _repository.stream.first;

      final list = <CollectionChooseItem>[];

      map.forEach((name, gifs) {
        final Gif? gif =
            gifs.isNotEmpty ? gifs.first.sources.originalGif : null;

        final containsGif =
            gifs.indexWhere((element) => element.id == gifBundle.id) == -1
                ? GifCollectionStatus.notIncluded
                : GifCollectionStatus.included;

        list.add(CollectionChooseItem(name, gif, containsGif));
      });

      _lastCollectionChooseItemList = list;

      emit(CollectionChooseListUpdate(list));
    });

    add(LoadOrRefreshChooseData());

    _favouritesBloc.stream.listen(
      (event) {
        if (event is FavouritesUpdated) add(LoadOrRefreshChooseData());
      },
    );
  }

  void _changeStatusOfCollectionAndEmit(
      Emitter emit, String collectionName, GifCollectionStatus status) {
    final index = _lastCollectionChooseItemList
        .indexWhere((element) => element.name == collectionName);

    _lastCollectionChooseItemList[index] = _lastCollectionChooseItemList[index]
        .copyWith(gifCollectionStatus: status);

    emit(CollectionChooseListUpdate(_lastCollectionChooseItemList));
  }
}
