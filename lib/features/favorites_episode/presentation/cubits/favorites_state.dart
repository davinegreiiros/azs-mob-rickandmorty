import 'package:equatable/equatable.dart';
import '../../../episodes/domain/entities/episode.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<Episode> episodes;
  final Set<String> watchedIds;

  const FavoritesLoaded({
    required this.episodes,
    required this.watchedIds,
  });

  @override
  List<Object?> get props => [episodes, watchedIds];
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
