import 'package:equatable/equatable.dart';
import '../../../episodes/domain/entities/episode.dart';
import '../../../episodes/domain/entities/character.dart';

abstract class EpisodeDetailState extends Equatable {
  const EpisodeDetailState();

  @override
  List<Object?> get props => [];
}

class EpisodeDetailInitial extends EpisodeDetailState {
  const EpisodeDetailInitial();
}

class EpisodeDetailLoading extends EpisodeDetailState {
  const EpisodeDetailLoading();
}

class EpisodeDetailLoaded extends EpisodeDetailState {
  final Episode episode;
  final List<Character> characters;
  final bool isFavorite;
  final bool isWatched;

  const EpisodeDetailLoaded({
    required this.episode,
    required this.characters,
    required this.isFavorite,
    required this.isWatched,
  });

  EpisodeDetailLoaded copyWith({
    bool? isFavorite,
    bool? isWatched,
  }) {
    return EpisodeDetailLoaded(
      episode: episode,
      characters: characters,
      isFavorite: isFavorite ?? this.isFavorite,
      isWatched: isWatched ?? this.isWatched,
    );
  }

  @override
  List<Object?> get props => [episode, characters, isFavorite, isWatched];
}

class EpisodeDetailError extends EpisodeDetailState {
  final String message;
  const EpisodeDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
