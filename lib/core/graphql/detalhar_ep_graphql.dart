import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_eps/core/errors/app_exception.dart';
import 'package:rick_and_morty_eps/core/network/graphql_client.dart';

class DetalharEpGraphQL {
  static const _query = r'''
    query Episode($id: ID!) {
      episode(id: $id) {
        id
        name
        air_date
        episode
        characters {
          id
          name
          status
          species
          image
        }
      }
    }
  ''';

  Future<Map<String, dynamic>> call(String id) async {
    final client = await GraphQlApi.init();

    final result = await client.query(
      QueryOptions(
        document: gql(_query),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.hasException) {
      GraphQlApi.logger.e('Erro ao detalhar episódio $id: ${result.exception}');
      throw AppException.fromOperationException(result.exception!);
    }

    return result.data!['episode'] as Map<String, dynamic>;
  }
}
