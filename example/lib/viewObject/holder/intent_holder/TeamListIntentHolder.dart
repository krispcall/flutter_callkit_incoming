import "package:flutter/material.dart";

class TeamListIntentHolder {
  const TeamListIntentHolder({
    required this.teamId,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final String teamId;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
