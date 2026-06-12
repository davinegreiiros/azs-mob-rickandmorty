import '../../../../core/usecases/usecase.dart';
import '../entities/character.dart';
import '../repositories/episode_repository.dart';

class GetEpisodeDetailUseCase implements UseCase<List<Character>, String> {
  final EpisodeRepository repository;
  GetEpisodeDetailUseCase(this.repository);

  @override
  Future<List<Character>> call(String episodeId) =>
      repository.getEpisodeCharacters(episodeId);
}
