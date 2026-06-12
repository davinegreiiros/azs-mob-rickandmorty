import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_eps/core/errors/app_exception.dart';
import 'package:rick_and_morty_eps/core/network/graphql_client.dart';

class ListarEpsGraphQL {
  static const _query = r'''
    query Episodes($page: Int, $filter: FilterEpisode) {
      episodes(page: $page, filter: $filter) {
        info {
          count
          pages
          next
          prev
        }
        results {
          id
          name
          air_date
          episode
          characters {
            id
          }
        }
      }
    }
  ''';

  Future<Map<String, dynamic>> call({int page = 1, String? name}) async {
    final client = await GraphQlApi.init();

    final result = await client.query(
      QueryOptions(
        document: gql(_query),
        variables: {
          'page': page,
          'filter': name != null ? {'name': name} : null,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      GraphQlApi.logger.e('Erro ao listar episódios: ${result.exception}');
      throw AppException.fromOperationException(result.exception!);
    }

    return result.data!['episodes'] as Map<String, dynamic>;
  }
}
