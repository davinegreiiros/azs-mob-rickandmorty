import '../../../../core/usecases/usecase.dart';
import '../entities/episode.dart';
import '../repositories/episode_repository.dart';

class GetFavoritesUseCase implements UseCase<List<Episode>, NoParams> {
  final EpisodeRepository repository;
  GetFavoritesUseCase(this.repository);

  @override
  Future<List<Episode>> call(NoParams params) => repository.getFavoriteEpisodes();
}
