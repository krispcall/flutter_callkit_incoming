import "dart:ui";

import "package:flutter/material.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class NumberSettingIntentHolder {
  const NumberSettingIntentHolder({
    this.channel,
    this.onUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final WorkspaceChannel? channel;
  final VoidCallback? onUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
