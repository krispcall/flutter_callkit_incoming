import "package:flutter/cupertino.dart";

class MessageDetailIntentHolder {
  const MessageDetailIntentHolder({
    this.clientId,
    this.clientPhoneNumber,
    this.clientName,
    this.clientProfilePicture,
    this.lastChatted,
    this.channelId,
    this.channelName,
    this.channelNumber,
    this.countryId,
    this.isBlocked,
    // required this.dndMissed,
    this.isContact,
    this.onIncomingTap,
    this.onOutgoingTap,
    this.makeCallWithSid,
    this.onContactBlocked,
  });

  final String? clientId;
  final String? clientPhoneNumber;
  final String? clientName;
  final String? clientProfilePicture;
  final String? countryId;
  final String? lastChatted;
  final String? channelId;
  final String? channelName;
  final String? channelNumber;
  final bool? isBlocked;
  // final bool dndMissed;
  final bool? isContact;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final Function(String?, String?, String?, String?, String?, String?, String?, String?,
      String?, String?)? makeCallWithSid;
  final Function(bool)? onContactBlocked;
}
