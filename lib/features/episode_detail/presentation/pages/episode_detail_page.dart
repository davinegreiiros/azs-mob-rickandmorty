import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../episodes/domain/entities/episode.dart';
import '../../../episodes/domain/repositories/episode_repository.dart';
import '../../../episodes/domain/usecases/get_episode_detail_usecase.dart';
import '../../../episodes/domain/usecases/toggle_favorite_usecase.dart';
import '../../../episodes/domain/usecases/toggle_watched_usecase.dart';
import '../cubits/episode_detail_cubit.dart';
import '../cubits/episode_detail_state.dart';
import '../widgets/character_card.dart';

class EpisodeDetailPage extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailPage({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<EpisodeRepository>();

    return BlocProvider(
      create: (_) => EpisodeDetailCubit(
        getDetail: GetEpisodeDetailUseCase(repository),
        toggleFavorite: ToggleFavoriteUseCase(repository),
        toggleWatched: ToggleWatchedUseCase(repository),
        repository: repository,
      )..loadDetail(episode),
      child: const _EpisodeDetailView(),
    );
  }
}

class _EpisodeDetailView extends StatelessWidget {
  const _EpisodeDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodeDetailCubit, EpisodeDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bgApp,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: switch (state) {
              EpisodeDetailLoaded(:final episode) => Text(episode.episode),
              _ => const SizedBox.shrink(),
            },
            actions: [
              if (state is EpisodeDetailLoaded) ...[
                _WatchedButton(
                  isWatched: state.isWatched,
                  onTap: () =>
                      context.read<EpisodeDetailCubit>().toggleWatched(),
                ),
                _FavoriteButton(
                  isFavorite: state.isFavorite,
                  onTap: () {
                    final adding = !state.isFavorite;
                    context.read<EpisodeDetailCubit>().toggleFavorite();
                    _showFavoriteSnackBar(context, adding);
                  },
                ),
              ],
            ],
          ),
          body: switch (state) {
            EpisodeDetailInitial() || EpisodeDetailLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.portal500),
              ),
            EpisodeDetailError(:final message) => _ErrorView(message: message),
            EpisodeDetailLoaded() => _LoadedBody(state: state),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final EpisodeDetailLoaded state;
  const _LoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _EpisodeHeader(state: state),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.groups_rounded,
                    size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  'PERSONAGENS · ${state.characters.length}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 0.88,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: state.characters.length,
          separatorBuilder: (_, __) => const Divider(
            indent: 20,
            endIndent: 20,
            color: AppColors.borderSubtle,
          ),
          itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CharacterCard(character: state.characters[index]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _EpisodeHeader extends StatelessWidget {
  final EpisodeDetailLoaded state;
  const _EpisodeHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final ep = state.episode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CodeBadge(code: ep.episode),
              if (state.isWatched) ...[
                const SizedBox(width: 8),
                _SeenChip(),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ep.name,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                ep.airDate,
                style: GoogleFonts.karla(
                    fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CodeBadge extends StatelessWidget {
  final String code;
  const _CodeBadge({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: GoogleFonts.spaceMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.portal300,
          letterSpacing: 0.88,
        ),
      ),
    );
  }
}

class _SeenChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.cyanSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 12, color: AppColors.cyan400),
          const SizedBox(width: 4),
          Text(
            'VISTO',
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.cyan400,
              letterSpacing: 0.88,
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchedButton extends StatelessWidget {
  final bool isWatched;
  final VoidCallback onTap;
  const _WatchedButton({required this.isWatched, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isWatched ? 'Marcado como visto' : 'Marcar como visto',
      icon: Icon(
        isWatched
            ? Icons.check_circle_rounded
            : Icons.check_circle_outline_rounded,
        color: isWatched ? AppColors.cyan400 : AppColors.textMuted,
      ),
      onPressed: onTap,
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavorite ? 'Desfavoritar' : 'Favoritar',
      icon: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
        color: isFavorite ? AppColors.star400 : AppColors.textMuted,
      ),
      onPressed: onTap,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

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
              'Não foi possível carregar',
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
            Text(adding ? 'Adicionado aos favoritos' : 'Removido dos favoritos'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
