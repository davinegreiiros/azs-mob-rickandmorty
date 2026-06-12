import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/app_bloc_providers.dart';
import 'core/graphql/detalhar_ep_graphql.dart';
import 'core/graphql/listar_eps_graphql.dart';
import 'core/graphql/listar_eps_por_ids_graphql.dart';
import 'core/network/graphql_client.dart';
import 'core/theme/app_theme.dart';
import 'features/episodes/data/datasources/episode_local_datasource.dart';
import 'features/episodes/data/datasources/episode_remote_datasource.dart';
import 'features/episodes/data/repositories/episode_repository_impl.dart';
import 'features/episodes/domain/repositories/episode_repository.dart';
import 'features/episodes/presentation/pages/episodes_list_page.dart';
import 'features/favorites_episode/presentation/cubits/favorites_cubit.dart';
import 'features/favorites_episode/presentation/pages/favorites_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GraphQlApi.init();
  final prefs = await SharedPreferences.getInstance();

  final repository = EpisodeRepositoryImpl(
    remoteDataSource: EpisodeRemoteDataSourceImpl(
      listarEps: ListarEpsGraphQL(),
      detalharEp: DetalharEpGraphQL(),
      listarEpsPorIds: ListarEpsPorIdsGraphQL(),
    ),
    localDataSource: EpisodeLocalDataSourceImpl(prefs: prefs),
  );

  runApp(RickAndMortyApp(repository: repository));
}

class RickAndMortyApp extends StatelessWidget {
  final EpisodeRepository repository;

  const RickAndMortyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<EpisodeRepository>.value(
      value: repository,
      child: MaterialApp(
        title: 'Rick & Morty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: AppBlocProviders(repository: repository, child: const _AppShell()),
      ),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _currentIndex = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.subscriptions_outlined),
      selectedIcon: Icon(Icons.subscriptions_rounded),
      label: 'Episódios',
    ),
    NavigationDestination(
      icon: Icon(Icons.star_border_rounded),
      selectedIcon: Icon(Icons.star_rounded),
      label: 'Favoritos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          EpisodesListPage(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) {
            context.read<FavoritesCubit>().loadFavorites();
          }
        },
        destinations: _destinations,
      ),
    );
  }
}
