import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_and_morty_eps/features/episodes/presentation/cubits/episodes_list_cubit.dart';
import 'package:rick_and_morty_eps/features/episodes/presentation/cubits/episodes_list_state.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../../features/episode_detail/presentation/pages/episode_detail_page.dart';
import '../widgets/episode_card.dart';

class EpisodesListPage extends StatefulWidget {
  const EpisodesListPage({super.key});

  @override
  State<EpisodesListPage> createState() => _EpisodesListPageState();
}

class _EpisodesListPageState extends State<EpisodesListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<EpisodesListCubit>().updateSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Rick & Morty',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _SearchInput(
              controller: _searchController,
              onClear: () => context.read<EpisodesListCubit>().updateSearch(''),
            ),
          ),
        ),
      ),
      body: BlocBuilder<EpisodesListCubit, EpisodesListState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: switch (state) {
            EpisodesListLoading() => const SkeletonEpisodeList(
                key: ValueKey('loading'),
                count: 6,
              ),
            EpisodesListError(:final message) => _ErrorView(
                key: const ValueKey('error'),
                message: message,
                onRetry: () => context.read<EpisodesListCubit>().loadEpisodes(),
              ),
            EpisodesListLoaded() => Column(
                key: const ValueKey('loaded'),
                children: [
                  _SeasonFilterBar(
                    selected: state.selectedSeason,
                    onSelect: (s) =>
                        context.read<EpisodesListCubit>().selectSeason(s),
                  ),
                  Expanded(
                    child: _EpisodesList(
                      state: state,
                      scrollController: _scrollController,
                    ),
                  ),
                ],
              ),
            _ => const SizedBox.shrink(key: ValueKey('initial')),
          },
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _SearchInput({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.karla(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar episódio pelo nome…',
        prefixIcon: const Icon(Icons.search_rounded, size: 22),
        suffixIcon: ValueListenableBuilder(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    controller.clear();
                    onClear();
                  },
                ),
        ),
      ),
    );
  }
}

class _SeasonFilterBar extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelect;

  const _SeasonFilterBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _SeasonChip(
            label: 'Todos',
            active: selected == null,
            onTap: () => onSelect(null),
          ),
          ...List.generate(5, (i) {
            final season = i + 1;
            return _SeasonChip(
              label: 'T$season',
              active: selected == season,
              onTap: () => onSelect(season == selected ? null : season),
            );
          }),
        ],
      ),
    );
  }
}

class _SeasonChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SeasonChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: active ? AppColors.portal500 : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? AppColors.portal500 : AppColors.borderSubtle,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.bgApp : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodesList extends StatelessWidget {
  final EpisodesListLoaded state;
  final ScrollController scrollController;

  const _EpisodesList({
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final episodes = state.filteredEpisodes;

    if (episodes.isEmpty) {
      return _EmptyState(
        query: state.searchQuery,
        hasSeasonFilter: state.selectedSeason != null,
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      itemCount: episodes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return EpisodeCard(
          episode: episode,
          isFavorite: state.favoriteIds.contains(episode.id),
          isWatched: state.watchedIds.contains(episode.id),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EpisodeDetailPage(episode: episode),
              ),
            );
            if (context.mounted) {
              context.read<EpisodesListCubit>().refreshIds();
            }
          },
          onToggleFavorite: () {
            final adding = !state.favoriteIds.contains(episode.id);
            context.read<EpisodesListCubit>().toggleFavorite(episode.id);
            _showFavoriteSnackBar(context, adding);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final bool hasSeasonFilter;
  const _EmptyState({required this.query, required this.hasSeasonFilter});

  @override
  Widget build(BuildContext context) {
    final String title;
    final String subtitle;
    final IconData icon;

    if (query.isNotEmpty) {
      icon = Icons.search_off_rounded;
      title = 'Nenhum resultado para "$query"';
      subtitle = 'Tente buscar por outro nome.';
    } else if (hasSeasonFilter) {
      icon = Icons.tv_off_rounded;
      title = 'Nenhum episódio nesta temporada';
      subtitle = 'Selecione outra temporada ou toque em Todos.';
    } else {
      icon = Icons.subscriptions_outlined;
      title = 'Nenhum episódio encontrado';
      subtitle = 'Tente novamente mais tarde.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style:
                  GoogleFonts.karla(fontSize: 13, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 44, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Algo deu errado',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style:
                  GoogleFonts.karla(fontSize: 13, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showFavoriteSnackBar(BuildContext context, bool adding) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              adding ? Icons.star_rounded : Icons.star_border_rounded,
              size: 18,
              color: adding ? AppColors.star400 : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
                adding ? 'Adicionado aos favoritos' : 'Removido dos favoritos'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
