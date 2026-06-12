import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../episodes/domain/entities/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _Avatar(image: character.image, name: character.name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _translateSpecies(character.species),
                  style: GoogleFonts.karla(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _StatusBadge(status: character.status),
        ],
      ),
    );
  }

  static String _translateSpecies(String species) {
    const map = {
      'Human': 'Humano',
      'Alien': 'Alienígena',
      'Robot': 'Robô',
      'Animal': 'Animal',
      'Humanoid': 'Humanoide',
      'Mythological Creature': 'Criatura Mitológica',
    };
    return map[species] ?? species;
  }
}

class _Avatar extends StatelessWidget {
  final String image;
  final String name;

  const _Avatar({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.borderStrong, width: 2),
        ),
        color: AppColors.surfaceRaised,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (_, __) => const SizedBox.shrink(),
          errorWidget: (_, __, ___) => Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, dotColor) = switch (status) {
      'Alive' => ('Vivo', AppColors.statusAlive),
      'Dead'  => ('Morto', AppColors.statusDead),
      _       => ('Desconhecido', AppColors.statusUnknown),
    };

    final isAlive = status == 'Alive';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: isAlive
                ? [BoxShadow(color: AppColors.statusAlive.withOpacity(0.6), blurRadius: 6)]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.karla(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
