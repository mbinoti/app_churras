import 'package:flutter/material.dart';

ThemeData criarTema() {
  const terracota = Color(0xFF8E3B2F);
  const salvia = Color(0xFF6D8B74);
  const dourado = Color(0xFFD6A84F);
  const espresso = Color(0xFF2F2723);
  const creme = Color(0xFFFAF7F2);
  const bege = Color(0xFFF1ECE4);
  const cremeBranco = Color(0xFFFFFDF9);
  const terracotaClara = Color(0xFFF3D5CE);
  const salviaClara = Color(0xFFDCE8DE);
  const douradoClaro = Color(0xFFF5E4B5);

  final esquema =
      ColorScheme.fromSeed(
        seedColor: terracota,
        brightness: Brightness.light,
      ).copyWith(
        primary: terracota,
        onPrimary: Colors.white,
        primaryContainer: terracotaClara,
        onPrimaryContainer: const Color(0xFF5F1B12),
        secondary: salvia,
        onSecondary: Colors.white,
        secondaryContainer: salviaClara,
        onSecondaryContainer: const Color(0xFF263B2C),
        tertiary: dourado,
        onTertiary: const Color(0xFF3F2E00),
        tertiaryContainer: douradoClaro,
        onTertiaryContainer: const Color(0xFF2F2400),
        surface: creme,
        onSurface: espresso,
        onSurfaceVariant: espresso,
        outline: const Color(0xFFCFC4B8),
        outlineVariant: const Color(0xFFE3DAD0),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: creme,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 42,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      ),
      titleLarge: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 17, height: 1.25),
      bodyMedium: TextStyle(fontSize: 15, height: 1.25),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cremeBranco,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: espresso.withValues(alpha: 0.22)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: espresso.withValues(alpha: 0.22)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: terracota, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cremeBranco,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: const Color(0xFFD9D0C4).withValues(alpha: 0.8)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 78,
      backgroundColor: bege,
      indicatorColor: terracota,
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selecionado = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selecionado ? Colors.white : espresso,
          size: 25,
        );
      }),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: espresso),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: terracota,
      inactiveTrackColor: const Color(0xFFE3DCD3),
      thumbColor: terracota,
      overlayColor: terracota.withValues(alpha: 0.12),
      trackHeight: 6,
    ),
  );
}
