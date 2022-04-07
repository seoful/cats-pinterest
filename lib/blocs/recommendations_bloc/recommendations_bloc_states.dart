part of 'recommendations_bloc.dart';

@immutable
abstract class RecommendationBlocState {}

class RecommendationsInitial extends RecommendationBlocState {}

class RecommendationsLoading extends RecommendationBlocState {}
class RecommendationsLoadingError extends RecommendationBlocState {}

class RecommendationsLoaded extends RecommendationBlocState {

  final List<GifBundle> gifs;

  RecommendationsLoaded(this.gifs);

}
