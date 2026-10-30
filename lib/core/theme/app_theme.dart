import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Dark theme colors
  static const Color darkBackground = Color(0xFF090E1A);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkCard = Color(0xFF1A2236);
  static const Color darkCardElevated = Color(0xFF1F2B40);
  static const Color darkBorder = Color(0xFF2A3A52);

  // Primary - Electric Blue
  static const Color primary = Color(0xFF2979FF);
  static const Color primaryLight = Color(0xFF5393FF);
  static const Color primaryDark = Color(0xFF0052CC);
  static const Color primaryContainer = Color(0xFF0D1E3D);

  // Secondary - Cyan
  static const Color secondary = Color(0xFF00E5FF);
  static const Color secondaryLight = Color(0xFF6EFFFF);
  static const Color secondaryDark = Color(0xFF00B2CC);
  static const Color secondaryContainer = Color(0xFF001F26);

  // Accent - Electric teal
  static const Color accent = Color(0xFF00BCD4);

  // Text colors - Dark theme
  static const Color textPrimary = Color(0xFFF0F4FF);
  static const Color textSecondary = Color(0xFFB0BDD0);
  static const Color textMuted = Color(0xFF6B7A99);
  static const Color textDisabled = Color(0xFF3A4A60);

  // Status colors
  static const Color success = Color(0xFF00C896);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFFF4F5A);
  static const Color info = Color(0xFF2979FF);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF0F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E8F5);

  // Light text
  static const Color lightTextPrimary = Color(0xFF0D1E3D);
  static const Color lightTextSecondary = Color(0xFF3A5280);
  static const Color lightTextMuted = Color(0xFF6B7A99);

  // Resistor band colors
  static const Map<String, Color> resistorColors = {
    'Black': Color(0xFF1A1A1A),
    'Brown': Color(0xFF7B3F00),
    'Red': Color(0xFFCC0000),
    'Orange': Color(0xFFFF6600),
    'Yellow': Color(0xFFFFD700),
    'Green': Color(0xFF228B22),
    'Blue': Color(0xFF0052CC),
    'Violet': Color(0xFF9400D3),
    'Grey': Color(0xFF808080),
    'White': Color(0xFFF5F5F5),
    'Gold': Color(0xFFFFD700),
    'Silver': Color(0xFFC0C0C0),
  };

  // Gradient - Premium blue
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0052CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [secondary, Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [darkCard, darkCardElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.darkBackground,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.secondaryLight,
        surface: AppColors.darkSurface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.darkCard,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.darkBorder,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _buildTextTheme(
        AppColors.textPrimary,
        AppColors.textSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 22);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 22);
        }),
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black54,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.outfit(
          color: AppColors.textDisabled,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.outfit(color: AppColors.error, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: GoogleFonts.outfit(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.primaryContainer;
          return AppColors.darkCard;
        }),
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: const Color(0xFFD6E4FF),
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        secondaryContainer: const Color(0xFFCCF5FF),
        onSecondaryContainer: AppColors.secondaryDark,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: const Color(0xFFF5F8FF),
        onSurfaceVariant: AppColors.lightTextSecondary,
        outline: AppColors.lightBorder,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _buildTextTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: const Color(0xFFD6E4FF),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.lightTextMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 22);
          }
          return IconThemeData(color: AppColors.lightTextMuted, size: 22);
        }),
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.outfit(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.outfit(
          color: AppColors.lightTextMuted,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.outfit(color: AppColors.error, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedColor: const Color(0xFFD6E4FF),
        labelStyle: GoogleFonts.outfit(
          fontSize: 13,
          color: AppColors.lightTextSecondary,
        ),
        side: BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightCard,
        contentTextStyle: GoogleFonts.outfit(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
    );
  }
}
