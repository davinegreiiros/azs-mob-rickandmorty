import '../../../../core/usecases/usecase.dart';
import '../repositories/episode_repository.dart';

class ToggleFavoriteUseCase implements UseCase<void, String> {
  final EpisodeRepository repository;
  ToggleFavoriteUseCase(this.repository);

  @override
  Future<void> call(String episodeId) => repository.toggleFavorite(episodeId);
}
