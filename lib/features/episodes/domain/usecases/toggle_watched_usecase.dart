import '../../../../core/usecases/usecase.dart';
import '../repositories/episode_repository.dart';

class ToggleWatchedUseCase implements UseCase<void, String> {
  final EpisodeRepository repository;
  ToggleWatchedUseCase(this.repository);

  @override
  Future<void> call(String episodeId) => repository.toggleWatched(episodeId);
}
