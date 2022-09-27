/*
 * *
 *  * Created by Kedar on 8/10/21 1:10 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/10/21 1:10 PM
 *
 */

import "package:flutter/cupertino.dart";

class OverViewWorkspaceIntentHolder {
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final VoidCallback onUpdateCallback;

  OverViewWorkspaceIntentHolder({
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.onUpdateCallback,
  });
}
