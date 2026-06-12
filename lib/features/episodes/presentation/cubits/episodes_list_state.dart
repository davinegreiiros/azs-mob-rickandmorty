import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_eps/features/episodes/domain/entities/episode.dart';

abstract class EpisodesListState extends Equatable {
  const EpisodesListState();

  @override
  List<Object?> get props => [];
}

class EpisodesListInitial extends EpisodesListState {
  const EpisodesListInitial();
}

class EpisodesListLoading extends EpisodesListState {
  const EpisodesListLoading();
}

class EpisodesListLoaded extends EpisodesListState {
  final List<Episode> allEpisodes;
  final Set<String> favoriteIds;
  final Set<String> watchedIds;
  final int? selectedSeason;
  final String searchQuery;

  const EpisodesListLoaded({
    required this.allEpisodes,
    required this.favoriteIds,
    required this.watchedIds,
    this.selectedSeason,
    this.searchQuery = '',
  });

  List<Episode> get filteredEpisodes {
    var result = allEpisodes;
    if (selectedSeason != null) {
      result = result.where((e) => _seasonOf(e) == selectedSeason).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((e) => e.name.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  static int _seasonOf(Episode e) => int.parse(e.episode.substring(1, 3));

  EpisodesListLoaded copyWith({
    List<Episode>? allEpisodes,
    Set<String>? favoriteIds,
    Set<String>? watchedIds,
    int? Function()? selectedSeason,
    String? searchQuery,
  }) {
    return EpisodesListLoaded(
      allEpisodes: allEpisodes ?? this.allEpisodes,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      watchedIds: watchedIds ?? this.watchedIds,
      selectedSeason: selectedSeason != null ? selectedSeason() : this.selectedSeason,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [allEpisodes, favoriteIds, watchedIds, selectedSeason, searchQuery];
}

class EpisodesListError extends EpisodesListState {
  final String message;
  const EpisodesListError(this.message);

  @override
  List<Object?> get props => [message];
}
