import "package:flutter/material.dart";

class MemberListIntentHolder {
  const MemberListIntentHolder({
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
