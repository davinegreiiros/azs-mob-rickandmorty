import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../episodes/domain/repositories/episode_repository.dart';
import '../../../episodes/domain/usecases/get_favorites_usecase.dart';
import '../../../episodes/domain/usecases/toggle_favorite_usecase.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;
  final EpisodeRepository _repository;

  FavoritesCubit({
    required GetFavoritesUseCase getFavorites,
    required ToggleFavoriteUseCase toggleFavorite,
    required EpisodeRepository repository,
  })  : _getFavorites = getFavorites,
        _toggleFavorite = toggleFavorite,
        _repository = repository,
        super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      final (episodes, watchedIds) = await (
        _getFavorites(const NoParams()),
        _repository.getWatchedIds(),
      ).wait;

      emit(FavoritesLoaded(episodes: episodes, watchedIds: watchedIds));
    } catch (e) {
      emit(FavoritesError(resolveErrorMessage(e)));
    }
  }

  Future<void> removeFavorite(String episodeId) async {
    await _toggleFavorite(episodeId);
    final current = state;
    if (current is FavoritesLoaded) {
      emit(FavoritesLoaded(
        episodes: current.episodes.where((e) => e.id != episodeId).toList(),
        watchedIds: current.watchedIds,
      ));
    }
  }
}
