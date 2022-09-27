import "package:flutter/cupertino.dart";

class SearchConversationIntentHolder {
  final String? channelId;
  final String? contactNumber;
  final String? contactName;
  final AnimationController? animationController;
  final String? clientId;
  final bool? isFromMember;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  SearchConversationIntentHolder({
    this.channelId,
    this.contactNumber,
    this.contactName,
    this.animationController,
    this.clientId,
    this.isFromMember,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });
}
