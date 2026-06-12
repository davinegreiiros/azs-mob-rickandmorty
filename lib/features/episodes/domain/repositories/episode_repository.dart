import '../entities/episode.dart';
import '../entities/character.dart';

abstract class EpisodeRepository {
  Future<(List<Episode>, int)> getEpisodes({int page, String? name});
  Future<List<Character>> getEpisodeCharacters(String episodeId);
  Future<List<Episode>> getFavoriteEpisodes();
  Future<void> toggleFavorite(String episodeId);
  Future<void> toggleWatched(String episodeId);
  Future<Set<String>> getFavoriteIds();
  Future<Set<String>> getWatchedIds();
}
