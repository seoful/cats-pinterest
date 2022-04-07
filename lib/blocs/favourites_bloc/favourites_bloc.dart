import 'package:bloc/bloc.dart';
import 'package:cats/model/collection_item.dart';
import 'package:cats/repository/favourites_repository.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {

  late final _repository = Injector.appInstance.get<FavouritesRepository>();

  FavouritesBloc() : super(FavouritesInitial()) {
    on<LoadOrRefreshFavouritesData>((event, emit) async {

      if( !(await _repository.isLoaded.first)) {
        emit(FavouritesNotInitialized());
      }

      await _repository.isLoaded.stream.firstWhere((element) => element);

      final map = await _repository.stream.first;

      final collections = map.entries.map((e) => CollectionItem(e.key, e.value)).toList();

      emit(FavouritesUpdated(collections));
    });

    on<CreateCollection>((event, emit) async {
      emit(CreatingCollection());

      final success = await _repository.createCollection(event.name);

      if(!success) {
        emit(CollectionAlreadyExists());
        return;
      }

      emit(CollectionCreated());
      add(LoadOrRefreshFavouritesData());

    });

    on<DeleteCollection>((event, emit) async {
      emit(DeletingCollection());

      await _repository.deleteCollection(event.name);

      emit(CollectionDeleted());

      add(LoadOrRefreshFavouritesData());

    });

    add(LoadOrRefreshFavouritesData());
  }
}
