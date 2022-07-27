import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/utils/constants/font_family_enums.dart';
import 'package:kraken_pokedex/src/utils/theme/color_table.dart';
import 'package:kraken_pokedex/src/utils/theme/theme_data_table.dart';

class AppThemes {
  static ThemeData light = ThemeData(
    fontFamily: FontFamilyEnum.Orbitron.name,
    primaryColor: ColorTable.primaryColor,
    primaryColorLight: ColorTable.primaryColorLight,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: ColorTable.primaryColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: ColorTable.textColor,
      ),
    ),
    iconTheme: ThemeDataTable.lightThemeIconTheme,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: ThemeDataTable.lightThemeIconTheme,
      iconTheme: ThemeDataTable.lightThemeIconTheme,
    ),
    floatingActionButtonTheme: ThemeDataTable.fabButtonTheme,
  );
}
