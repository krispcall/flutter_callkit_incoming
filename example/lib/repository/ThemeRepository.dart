import "package:flutter/material.dart";
import "package:mvp/config/ThemeData.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/repository/Common/Respository.dart";

class PsThemeRepository extends Repository {

  PsThemeRepository({required PsSharedPreferences psSharedPreferences}) {
    _psSharedPreferences = psSharedPreferences;
  }

  PsSharedPreferences? _psSharedPreferences;

  Future<void> updateTheme(bool isDarkTheme) async {
    await _psSharedPreferences!.shared!
        .setBool(Const.THEME_IS_DARK_THEME, isDarkTheme);
  }

  ThemeData getTheme() {
    final bool isDarkTheme = _psSharedPreferences!.shared!.getBool(Const.THEME_IS_DARK_THEME) ?? false;
    if (isDarkTheme) {
      return themeData(ThemeData.dark());
    } else {
      return themeData(ThemeData.light());
    }
  }
}
