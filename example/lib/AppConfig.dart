import "package:flutter/material.dart";
import "package:mvp/AppConstant.dart";

class AppConfig extends InheritedWidget {
  const AppConfig({
    required this.liveUrl,
    required this.socketUrl,
    required this.appSubscriptionEndpoint,
    required this.imageUrl,
    required this.countryLogoUrl,
    required this.nameConfig,
    required Widget child,
  }) : super(child: child);

  final String? liveUrl;
  final String? socketUrl;
  final String? appSubscriptionEndpoint;
  final String? imageUrl;
  final String? countryLogoUrl;
  final AppConstant? nameConfig;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
