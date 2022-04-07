import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/network/gif_get_service.dart';
import 'package:chopper/chopper.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';


part 'recommendations_bloc_events.dart';

part 'recommendations_bloc_states.dart';

class RecommendationsBloc extends Bloc<RecommendationsBlocEvent, RecommendationBlocState> {
  final ChopperClient api = Injector.appInstance.get<ChopperClient>();

  static const int _numberOfGifs = 16;

  RecommendationsBloc() : super(RecommendationsInitial()) {
    on<LoadRecommendations>((event, emit) async {
      emit(RecommendationsLoading());
      final gifs = await Future.wait(_generateFutures());

      if(!_checkForNulls(gifs)) {
        emit(RecommendationsLoadingError());
        return;
      }
      emit(RecommendationsLoaded(gifs.map((e) => e.body!).toList()));
    });
  }

  List<Future<Response<GifBundle>>> _generateFutures() {
    return List<Future<Response<GifBundle>>>.generate(
        _numberOfGifs, (_) => api.getService<GifGetService>().getRandomGif());
  }

  bool _checkForNulls(List<Response<GifBundle>> list) {
    for (int i = 0; i < list.length; i++) {
      if(list[i].body == null) return false;
    }
    return true;
  }


}
