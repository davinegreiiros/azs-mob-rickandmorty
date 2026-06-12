import 'package:rick_and_morty_eps/core/graphql/detalhar_ep_graphql.dart';
import 'package:rick_and_morty_eps/core/graphql/listar_eps_graphql.dart';
import 'package:rick_and_morty_eps/core/graphql/listar_eps_por_ids_graphql.dart';
import '../models/episode_model.dart';
import '../models/character_model.dart';

abstract class EpisodeRemoteDataSource {
  Future<(List<EpisodeModel>, int)> getEpisodes({int page, String? name});
  Future<List<CharacterModel>> getEpisodeCharacters(String episodeId);
  Future<List<EpisodeModel>> getEpisodesByIds(List<String> ids);
}

class EpisodeRemoteDataSourceImpl implements EpisodeRemoteDataSource {
  final ListarEpsGraphQL listarEps;
  final DetalharEpGraphQL detalharEp;
  final ListarEpsPorIdsGraphQL listarEpsPorIds;

  EpisodeRemoteDataSourceImpl({
    required this.listarEps,
    required this.detalharEp,
    required this.listarEpsPorIds,
  });

  @override
  Future<(List<EpisodeModel>, int)> getEpisodes({int page = 1, String? name}) async {
    final data = await listarEps.call(page: page, name: name);
    final info = data['info'] as Map<String, dynamic>;
    final totalPages = info['pages'] as int;
    final results = data['results'] as List<dynamic>;
    final models = results.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>)).toList();
    return (models, totalPages);
  }

  @override
  Future<List<CharacterModel>> getEpisodeCharacters(String episodeId) async {
    final data = await detalharEp.call(episodeId);
    final characters = data['characters'] as List<dynamic>;
    return characters.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<EpisodeModel>> getEpisodesByIds(List<String> ids) async {
    final data = await listarEpsPorIds.call(ids);
    return data.map((e) => EpisodeModel.fromJson(e)).toList();
  }
}
