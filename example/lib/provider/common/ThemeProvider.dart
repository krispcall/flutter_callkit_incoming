import "package:flutter/material.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/ThemeRepository.dart";

class ThemeProvider extends Provider {
  ThemeProvider({required PsThemeRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
  }
  PsThemeRepository? _repo;

  Future<dynamic> updateTheme(bool isDarkTheme) {
    return _repo!.updateTheme(isDarkTheme);
  }

  ThemeData getTheme() {
    return _repo!.getTheme();
  }
}
