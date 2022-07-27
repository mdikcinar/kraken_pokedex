import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/utils/theme/color_table.dart';

class ThemeDataTable {
  static const darkThemeIconTheme = IconThemeData(
    color: ColorTable.darkThemeTextColor,
  );
  static const lightThemeIconTheme = IconThemeData(
    color: ColorTable.textColor,
  );
  static const fabButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: ColorTable.primaryColor,
  );
}
