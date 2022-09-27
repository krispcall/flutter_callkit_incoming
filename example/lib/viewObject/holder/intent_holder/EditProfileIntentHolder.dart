import "dart:core";

import "package:flutter/cupertino.dart";

class EditProfileIntentHolder {
  const EditProfileIntentHolder({
    required this.whichToEdit,
    required this.onProfileUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final String whichToEdit;
  final VoidCallback onProfileUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
