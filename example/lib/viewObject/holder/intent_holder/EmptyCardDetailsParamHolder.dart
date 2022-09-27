import "dart:core";

import "package:flutter/cupertino.dart";
import "package:mvp/provider/user/UserProvider.dart";

class EmptyCardDetailsParamHolder {
  const EmptyCardDetailsParamHolder({
    required this.onContinueToWebsiteClick,
    required this.onLogoutClick,
    required this.userProvider,
  });

  final VoidCallback onContinueToWebsiteClick;
  final VoidCallback onLogoutClick;
  final UserProvider userProvider;
}
