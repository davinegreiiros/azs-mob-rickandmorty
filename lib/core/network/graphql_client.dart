import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';

const _kGraphQLEndpoint = 'https://rickandmortyapi.com/graphql';

class GraphQlApi {
  static final logger = Logger();
  static GraphQLClient? _instance;

  static Future<GraphQLClient> init() async {
    if (_instance != null) return _instance!;

    await initHiveForFlutter();

    final link = HttpLink(_kGraphQLEndpoint);

    _instance = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: await HiveStore.open()),
      queryRequestTimeout: const Duration(seconds: 30),
    );

    logger.i('GraphQLClient inicializado — $_kGraphQLEndpoint');
    return _instance!;
  }
}
