import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../episodes/domain/entities/episode.dart';
import '../../../episodes/domain/repositories/episode_repository.dart';
import '../../../episodes/domain/usecases/get_episode_detail_usecase.dart';
import '../../../episodes/domain/usecases/toggle_favorite_usecase.dart';
import '../../../episodes/domain/usecases/toggle_watched_usecase.dart';
import 'episode_detail_state.dart';

class EpisodeDetailCubit extends Cubit<EpisodeDetailState> {
  final GetEpisodeDetailUseCase _getDetail;
  final ToggleFavoriteUseCase _toggleFavorite;
  final ToggleWatchedUseCase _toggleWatched;
  final EpisodeRepository _repository;

  EpisodeDetailCubit({
    required GetEpisodeDetailUseCase getDetail,
    required ToggleFavoriteUseCase toggleFavorite,
    required ToggleWatchedUseCase toggleWatched,
    required EpisodeRepository repository,
  })  : _getDetail = getDetail,
        _toggleFavorite = toggleFavorite,
        _toggleWatched = toggleWatched,
        _repository = repository,
        super(const EpisodeDetailInitial());

  Future<void> loadDetail(Episode episode) async {
    emit(const EpisodeDetailLoading());
    try {
      final (characters, favoriteIds, watchedIds) = await (
        _getDetail(episode.id),
        _repository.getFavoriteIds(),
        _repository.getWatchedIds(),
      ).wait;

      emit(EpisodeDetailLoaded(
        episode: episode,
        characters: characters,
        isFavorite: favoriteIds.contains(episode.id),
        isWatched: watchedIds.contains(episode.id),
      ));
    } catch (e) {
      emit(EpisodeDetailError(resolveErrorMessage(e)));
    }
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (current is! EpisodeDetailLoaded) return;
    await _toggleFavorite(current.episode.id);
    emit(current.copyWith(isFavorite: !current.isFavorite));
  }

  Future<void> toggleWatched() async {
    final current = state;
    if (current is! EpisodeDetailLoaded) return;
    await _toggleWatched(current.episode.id);
    emit(current.copyWith(isWatched: !current.isWatched));
  }
}
