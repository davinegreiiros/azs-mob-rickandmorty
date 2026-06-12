import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/usecases/get_episodes_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/toggle_watched_usecase.dart';
import '../../domain/repositories/episode_repository.dart';
import 'episodes_list_state.dart';

class EpisodesListCubit extends Cubit<EpisodesListState> {
  final GetEpisodesUseCase _getEpisodes;
  final ToggleFavoriteUseCase _toggleFavorite;
  final ToggleWatchedUseCase _toggleWatched;
  final EpisodeRepository _repository;

  EpisodesListCubit({
    required GetEpisodesUseCase getEpisodes,
    required ToggleFavoriteUseCase toggleFavorite,
    required ToggleWatchedUseCase toggleWatched,
    required EpisodeRepository repository,
  })  : _getEpisodes = getEpisodes,
        _toggleFavorite = toggleFavorite,
        _toggleWatched = toggleWatched,
        _repository = repository,
        super(const EpisodesListInitial());

  Future<void> loadEpisodes() async {
    emit(const EpisodesListLoading());
    try {
      final (firstBatch, totalPages) =
          await _getEpisodes(const GetEpisodesParams(page: 1));

      final all = [...firstBatch];

      if (totalPages > 1) {
        final futures = [
          for (int p = 2; p <= totalPages; p++)
            _getEpisodes(GetEpisodesParams(page: p)).then((r) => r.$1),
        ];
        final remaining = await Future.wait(futures);
        for (final batch in remaining) {
          all.addAll(batch);
        }
      }

      final (favoriteIds, watchedIds) = await (
        _repository.getFavoriteIds(),
        _repository.getWatchedIds(),
      ).wait;

      emit(EpisodesListLoaded(
        allEpisodes: all,
        favoriteIds: favoriteIds,
        watchedIds: watchedIds,
      ));
    } catch (e) {
      emit(EpisodesListError(resolveErrorMessage(e)));
    }
  }

  void selectSeason(int? season) {
    final current = state;
    if (current is! EpisodesListLoaded) return;
    emit(current.copyWith(selectedSeason: () => season));
  }

  void updateSearch(String query) {
    final current = state;
    if (current is! EpisodesListLoaded) return;
    emit(current.copyWith(searchQuery: query));
  }

  Future<void> toggleFavorite(String episodeId) async {
    await _toggleFavorite(episodeId);
    final current = state;
    if (current is EpisodesListLoaded) {
      final updated = Set<String>.from(current.favoriteIds);
      updated.contains(episodeId)
          ? updated.remove(episodeId)
          : updated.add(episodeId);
      emit(current.copyWith(favoriteIds: updated));
    }
  }

  Future<void> toggleWatched(String episodeId) async {
    await _toggleWatched(episodeId);
    final current = state;
    if (current is EpisodesListLoaded) {
      final updated = Set<String>.from(current.watchedIds);
      updated.contains(episodeId)
          ? updated.remove(episodeId)
          : updated.add(episodeId);
      emit(current.copyWith(watchedIds: updated));
    }
  }

  Future<void> refreshIds() async {
    final current = state;
    if (current is! EpisodesListLoaded) return;
    final (favoriteIds, watchedIds) = await (
      _repository.getFavoriteIds(),
      _repository.getWatchedIds(),
    ).wait;
    emit(current.copyWith(favoriteIds: favoriteIds, watchedIds: watchedIds));
  }
}
