import 'package:bloc/bloc.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/network/gif_get_service.dart';
import 'package:chopper/chopper.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';

part 'search_bloc_events.dart';

part 'search_bloc_states.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final responseLimit = 25;

  bool _initialLoadSuccessful = false;

  final ChopperClient api = Injector.appInstance.get<ChopperClient>();
  late GiphyResponse _lastGiphyResponse;

  var _query = "";

  final _gifs = <GifBundle>[];

  SearchBloc() : super(MainGifScreenInitialLoad()) {
    on<SearchMoreGifs>((event, emit) async {
      if(_query != event.query) {
        _query = event.query;
        _initialLoadSuccessful = false;
        _gifs.clear();
      }
      if (!_initialLoadSuccessful) {
        emit(SearchFirstPageLoading());
      } else {
        emit(SearchLoadingNextPage(_gifs));
      }

      final response = await api.getService<GifGetService>().getGifs(
            responseLimit,
            _initialLoadSuccessful
                ? _lastGiphyResponse.pagination.offset +
                    _lastGiphyResponse.pagination.count
                : 0,
            "",
            _query,
          );
      if (response.isSuccessful) {
        _initialLoadSuccessful = true;

        if(response.body!.data.isEmpty){
          emit(SearchLoadedNothing());
          return;
        }

        _lastGiphyResponse = response.body!;

        _gifs.addAll(response.body!.data);

        final pagination = response.body!.pagination;
        if (pagination.offset + pagination.count >= pagination.totalCount) {
          emit(SearchLoadedToEnd(_gifs));
        } else {
          emit(SearchLoaded(_gifs));
        }
      } else {
        emit(_initialLoadSuccessful ? SearchLoadingNextPageError() : SearchFirstPageLoadingFail());
      }
    });
  }
}
