import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/episode.dart';

class EpisodeCard extends StatefulWidget {
  final Episode episode;
  final bool isFavorite;
  final bool isWatched;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const EpisodeCard({
    super.key,
    required this.episode,
    required this.isFavorite,
    required this.isWatched,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.99 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _pressed ? AppColors.surfaceRaised : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed ? AppColors.borderStrong : AppColors.borderSubtle,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _EpisodeCodeBadge(code: widget.episode.episode),
                          if (widget.isWatched) ...[
                            const SizedBox(width: 8),
                            const _SeenFlag(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.episode.name,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            widget.episode.airDate,
                            style: GoogleFonts.karla(fontSize: 13, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.groups_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.episode.characterCount} personagens',
                            style: GoogleFonts.karla(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _FavoriteButton(
                  isFavorite: widget.isFavorite,
                  onTap: widget.onToggleFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodeCodeBadge extends StatelessWidget {
  final String code;
  const _EpisodeCodeBadge({required this.code});

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

class _SeenFlag extends StatelessWidget {
  const _SeenFlag();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.cyan400),
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
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 44,
          height: 44,
          decoration: widget.isFavorite
              ? const BoxDecoration(
                  color: AppColors.starSoft,
                  shape: BoxShape.circle,
                )
              : null,
          child: Icon(
            widget.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: widget.isFavorite ? AppColors.star400 : AppColors.textMuted,
            size: 24,
          ),
        ),
      ),
    );
  }
}
