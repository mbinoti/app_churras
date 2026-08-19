import 'package:flutter/material.dart';

ThemeData criarTema() {
  const vermelho = Color(0xFFA7120D);
  const vermelhoEscuro = Color(0xFF8F0D08);
  const laranja = Color(0xFFFF7A12);
  const mostarda = Color(0xFF8A6900);
  const espresso = Color(0xFF3B2B2A);
  const fundo = Color(0xFFFFF8FF);
  const superficie = Color(0xFFFFFBFF);
  const navBackground = Color(0xFFF6EFF7);
  const vermelhoClaro = Color(0xFFF8D9D5);
  const laranjaClara = Color(0xFFFFE5D3);
  const mostardaClara = Color(0xFFF3E5B8);

  final esquema =
      ColorScheme.fromSeed(
        seedColor: vermelho,
        brightness: Brightness.light,
      ).copyWith(
        primary: vermelho,
        onPrimary: Colors.white,
        primaryContainer: vermelhoClaro,
        onPrimaryContainer: vermelhoEscuro,
        secondary: laranja,
        onSecondary: Colors.white,
        secondaryContainer: laranjaClara,
        onSecondaryContainer: const Color(0xFF7B2D0D),
        tertiary: mostarda,
        onTertiary: Colors.white,
        tertiaryContainer: mostardaClara,
        onTertiaryContainer: const Color(0xFF5E4700),
        surface: fundo,
        onSurface: espresso,
        onSurfaceVariant: espresso,
        outline: const Color(0xFFCDB8B7),
        outlineVariant: const Color(0xFFE7DDE7),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: fundo,
    fontFamily: 'Avenir Next',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 43,
        height: 1.04,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
      ),
      titleLarge: TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 18, height: 1.25),
      bodyMedium: TextStyle(fontSize: 16, height: 1.25),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: superficie,
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
        borderSide: const BorderSide(color: vermelho, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: superficie,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: const Color(0xFFE0CACA).withValues(alpha: 0.9)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 84,
      backgroundColor: navBackground,
      indicatorColor: laranja,
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selecionado = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selecionado ? espresso : const Color(0xFF634846),
          size: 24,
        );
      }),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: espresso),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: laranja,
      inactiveTrackColor: const Color(0xFFE3DDE4),
      thumbColor: laranja,
      overlayColor: laranja.withValues(alpha: 0.12),
      trackHeight: 6,
    ),
  );
}
