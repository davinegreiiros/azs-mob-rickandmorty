import '../../../../core/usecases/usecase.dart';
import '../entities/episode.dart';
import '../repositories/episode_repository.dart';

class GetEpisodesParams {
  final int page;
  final String? name;
  const GetEpisodesParams({this.page = 1, this.name});
}

class GetEpisodesUseCase implements UseCase<(List<Episode>, int), GetEpisodesParams> {
  final EpisodeRepository repository;
  GetEpisodesUseCase(this.repository);

  @override
  Future<(List<Episode>, int)> call(GetEpisodesParams params) =>
      repository.getEpisodes(page: params.page, name: params.name);
}
