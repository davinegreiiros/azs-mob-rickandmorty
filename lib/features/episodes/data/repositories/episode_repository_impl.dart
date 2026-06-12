import '../../domain/entities/episode.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/episode_repository.dart';
import '../datasources/episode_remote_datasource.dart';
import '../datasources/episode_local_datasource.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeRemoteDataSource remoteDataSource;
  final EpisodeLocalDataSource localDataSource;

  EpisodeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<(List<Episode>, int)> getEpisodes({int page = 1, String? name}) async {
    final (models, totalPages) = await remoteDataSource.getEpisodes(page: page, name: name);
    return (models.map((m) => m.toEntity()).toList(), totalPages);
  }

  @override
  Future<List<Character>> getEpisodeCharacters(String episodeId) async {
    final models = await remoteDataSource.getEpisodeCharacters(episodeId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Episode>> getFavoriteEpisodes() async {
    final ids = await localDataSource.getFavoriteIds();
    if (ids.isEmpty) return [];
    final models = await remoteDataSource.getEpisodesByIds(ids.toList());
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Set<String>> getFavoriteIds() => localDataSource.getFavoriteIds();

  @override
  Future<Set<String>> getWatchedIds() => localDataSource.getWatchedIds();

  @override
  Future<void> toggleFavorite(String episodeId) async {
    final ids = await localDataSource.getFavoriteIds();
    ids.contains(episodeId) ? ids.remove(episodeId) : ids.add(episodeId);
    await localDataSource.saveFavoriteIds(ids);
  }

  @override
  Future<void> toggleWatched(String episodeId) async {
    final ids = await localDataSource.getWatchedIds();
    ids.contains(episodeId) ? ids.remove(episodeId) : ids.add(episodeId);
    await localDataSource.saveWatchedIds(ids);
  }
}
