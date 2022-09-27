import "package:flutter/material.dart";

class NumberListIntentHolder {
  const NumberListIntentHolder({
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
