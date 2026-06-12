import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_eps/core/errors/app_exception.dart';
import 'package:rick_and_morty_eps/core/network/graphql_client.dart';

class ListarEpsPorIdsGraphQL {
  static const _query = r'''
    query EpisodesByIds($ids: [ID!]!) {
      episodesByIds(ids: $ids) {
        id
        name
        air_date
        episode
        characters {
          id
        }
      }
    }
  ''';

  Future<List<Map<String, dynamic>>> call(List<String> ids) async {
    if (ids.isEmpty) return [];

    final client = await GraphQlApi.init();

    final result = await client.query(
      QueryOptions(
        document: gql(_query),
        variables: {'ids': ids},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      GraphQlApi.logger.e('Erro ao buscar favoritos: ${result.exception}');
      throw AppException.fromOperationException(result.exception!);
    }

    final data = result.data!['episodesByIds'] as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }
}
