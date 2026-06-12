import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/skeletons.dart';
import '../../../episode_detail/presentation/pages/episode_detail_page.dart';
import '../../../episodes/presentation/widgets/episode_card.dart';
import '../cubits/favorites_cubit.dart';
import '../cubits/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favoritos',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: switch (state) {
            FavoritesInitial() || FavoritesLoading() => const SkeletonEpisodeList(
                key: ValueKey('loading'),
                count: 4,
              ),
            FavoritesError(:final message) => _ErrorView(
                key: const ValueKey('error'),
                message: message,
                onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
              ),
            FavoritesLoaded() => state.episodes.isEmpty
                ? const _EmptyState(key: ValueKey('empty'))
                : _FavoritesList(key: const ValueKey('list'), state: state),
            _ => const SizedBox.shrink(key: ValueKey('initial')),
          },
        ),
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  final FavoritesLoaded state;
  const _FavoritesList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: state.episodes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final episode = state.episodes[index];
        return EpisodeCard(
          episode: episode,
          isFavorite: true,
          isWatched: state.watchedIds.contains(episode.id),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EpisodeDetailPage(episode: episode),
            ),
          ),
          onToggleFavorite: () {
            context.read<FavoritesCubit>().removeFavorite(episode.id);
            _showFavoriteSnackBar(context, false);
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_border_rounded,
                size: 56, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Nenhum favorito ainda',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toque na estrela de um episódio para salvá-lo aqui.',
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
