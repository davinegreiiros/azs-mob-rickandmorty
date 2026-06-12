import 'package:graphql_flutter/graphql_flutter.dart';

class AppException implements Exception {
  final String userMessage;
  const AppException(this.userMessage);

  static AppException fromOperationException(OperationException e) {
    if (e.linkException != null) {
      final original = e.linkException?.originalException?.toString() ?? '';
      if (original.contains('SocketException') ||
          original.contains('Failed host lookup') ||
          original.contains('Connection refused') ||
          original.contains('NetworkException')) {
        return const AppException(
          'Sem conexão com a internet. Verifique sua rede e tente novamente.',
        );
      }
      if (original.contains('TimeoutException') ||
          original.contains('timed out')) {
        return const AppException(
          'A requisição demorou muito. Verifique sua conexão e tente novamente.',
        );
      }
      return const AppException(
        'Não foi possível conectar ao servidor. Tente novamente.',
      );
    }

    if (e.graphqlErrors.isNotEmpty) {
      final msg = e.graphqlErrors.first.message.toLowerCase();
      if (msg.contains('not found') || msg.contains('404')) {
        return const AppException('Episódio não encontrado.');
      }
      return const AppException(
        'Não foi possível carregar os dados. Tente novamente.',
      );
    }

    return const AppException('Algo deu errado. Tente novamente mais tarde.');
  }

  @override
  String toString() => userMessage;
}

String resolveErrorMessage(Object e) {
  if (e is AppException) return e.userMessage;
  return 'Algo deu errado. Tente novamente mais tarde.';
}
