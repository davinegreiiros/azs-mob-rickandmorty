import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_eps/features/episodes/presentation/cubits/episodes_list_cubit.dart';

import '../../features/episodes/domain/repositories/episode_repository.dart';
import '../../features/episodes/domain/usecases/get_episodes_usecase.dart';
import '../../features/episodes/domain/usecases/get_favorites_usecase.dart';
import '../../features/episodes/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/episodes/domain/usecases/toggle_watched_usecase.dart';
import '../../features/favorites_episode/presentation/cubits/favorites_cubit.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;

  late final EpisodesListCubit episodesListCubit = EpisodesListCubit(
    getEpisodes: GetEpisodesUseCase(_repository),
    toggleFavorite: ToggleFavoriteUseCase(_repository),
    toggleWatched: ToggleWatchedUseCase(_repository),
    repository: _repository,
  )..loadEpisodes();

  late final FavoritesCubit favoritesCubit = FavoritesCubit(
    getFavorites: GetFavoritesUseCase(_repository),
    toggleFavorite: ToggleFavoriteUseCase(_repository),
    repository: _repository,
  );

  final EpisodeRepository _repository;

  AppBlocProviders({
    super.key,
    required EpisodeRepository repository,
    required this.child,
  }) : _repository = repository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EpisodesListCubit>(create: (_) => episodesListCubit),
        BlocProvider<FavoritesCubit>(create: (_) => favoritesCubit),
      ],
      child: child,
    );
  }
}
