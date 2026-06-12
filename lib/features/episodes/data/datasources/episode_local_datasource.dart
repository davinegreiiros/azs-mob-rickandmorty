import 'package:shared_preferences/shared_preferences.dart';

abstract class EpisodeLocalDataSource {
  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);
  Future<Set<String>> getWatchedIds();
  Future<void> saveWatchedIds(Set<String> ids);
}

class EpisodeLocalDataSourceImpl implements EpisodeLocalDataSource {
  final SharedPreferences prefs;

  static const _favoritesKey = 'favorites';
  static const _watchedKey = 'watched';

  EpisodeLocalDataSourceImpl({required this.prefs});

  @override
  Future<Set<String>> getFavoriteIds() async =>
      prefs.getStringList(_favoritesKey)?.toSet() ?? {};

  @override
  Future<void> saveFavoriteIds(Set<String> ids) async =>
      prefs.setStringList(_favoritesKey, ids.toList());

  @override
  Future<Set<String>> getWatchedIds() async =>
      prefs.getStringList(_watchedKey)?.toSet() ?? {};

  @override
  Future<void> saveWatchedIds(Set<String> ids) async =>
      prefs.setStringList(_watchedKey, ids.toList());
}
