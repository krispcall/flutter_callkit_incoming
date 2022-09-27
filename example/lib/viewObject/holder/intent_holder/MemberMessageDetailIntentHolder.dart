import "package:flutter/cupertino.dart";

class MemberMessageDetailIntentHolder {
  const MemberMessageDetailIntentHolder({
    required this.clientId,
    required this.clientName,
    required this.clientProfilePicture,
    required this.onlineStatus,
    required this.clientEmail,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final String clientId;
  final String clientName;
  final String clientProfilePicture;
  final bool onlineStatus;
  final String clientEmail;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
