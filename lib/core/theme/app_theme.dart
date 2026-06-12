import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Paleta ─────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Fundos / superfícies
  static const bgApp        = Color(0xFF0C1018);
  static const surface1     = Color(0xFF111722);
  static const surfaceCard  = Color(0xFF161E2B);
  static const surfaceRaised = Color(0xFF202B3B);
  static const surfacePressed = Color(0xFF2C3A4F);

  // Portal verde — ação primária
  static const portal300 = Color(0xFFBFEA7D);
  static const portal400 = Color(0xFFA6E14F);
  static const portal500 = Color(0xFF97CE4C); // âncora da marca
  static const portal600 = Color(0xFF76B32E);
  static const accentSoft = Color(0x2497CE4C); // 14% opacidade

  // Ciano — estado "visto"
  static const cyan300 = Color(0xFF7CE8EE);
  static const cyan400 = Color(0xFF3FD8E0);
  static const cyanSoft = Color(0x1F3FD8E0); // 12% opacidade

  // Estrela — favoritos
  static const star400 = Color(0xFFFFD84D);
  static const starSoft = Color(0x24FFD84D); // 14% opacidade

  // Texto
  static const textPrimary   = Color(0xFFE8EDF4);
  static const textSecondary = Color(0xFF98A7BA);
  static const textMuted     = Color(0xFF6E8099);
  static const textOnAccent  = Color(0xFF070A10);

  // Status de personagem
  static const statusAlive   = Color(0xFF46D160);
  static const statusDead    = Color(0xFFE4574F);
  static const statusUnknown = Color(0xFF8C99A8);

  // Bordas
  static const borderSubtle = Color(0x14E8EDF4); // 8%
  static const borderStrong = Color(0x29E8EDF4); // 16%
  static const borderAccent = Color(0x7397CE4C); // 45%
}

// ─── Tipografia ──────────────────────────────────────────────────────────────

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLg(BuildContext ctx) => GoogleFonts.spaceGrotesk(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.15,
  );

  static TextStyle displayMd(BuildContext ctx) => GoogleFonts.spaceGrotesk(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.15,
  );

  static TextStyle titleLg(BuildContext ctx) => GoogleFonts.spaceGrotesk(
    fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3,
  );

  static TextStyle titleMd(BuildContext ctx) => GoogleFonts.spaceGrotesk(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3,
  );

  static TextStyle bodyMd(BuildContext ctx) => GoogleFonts.karla(
    fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5,
  );

  static TextStyle bodySm(BuildContext ctx) => GoogleFonts.karla(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.5,
  );

  static TextStyle labelMono(BuildContext ctx) => GoogleFonts.spaceMono(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.portal300,
    letterSpacing: 0.08 * 11,
  );

  static TextStyle labelMonoCyan(BuildContext ctx) => GoogleFonts.spaceMono(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.cyan300,
    letterSpacing: 0.08 * 11,
  );
}

// ─── Tema ────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgApp,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.portal500,
        onPrimary: AppColors.textOnAccent,
        secondary: AppColors.cyan400,
        onSecondary: AppColors.textOnAccent,
        tertiary: AppColors.star400,
        surface: AppColors.surfaceCard,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceRaised,
        outline: AppColors.borderStrong,
        outlineVariant: AppColors.borderSubtle,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgApp,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface1,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.accentSoft,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.portal400, size: 26);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 26);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.karla(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.portal400 : AppColors.textMuted,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface1,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderAccent),
        ),
        hintStyle: GoogleFonts.karla(fontSize: 15, color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 38, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        displayMedium: GoogleFonts.spaceGrotesk(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        headlineLarge: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        headlineMedium: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        titleLarge: GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.karla(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.karla(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.karla(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted),
        labelLarge: GoogleFonts.karla(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        labelSmall: GoogleFonts.spaceMono(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.portal300, letterSpacing: 0.88),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.portal500,
          foregroundColor: AppColors.textOnAccent,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
