import "package:flutter/cupertino.dart";

class AssignTagsIntentHolder {
  const AssignTagsIntentHolder({
    required this.clientId,
    required this.number,
    required this.onTap,
  });

  final String clientId;
  final String number;
  final VoidCallback onTap;
}
