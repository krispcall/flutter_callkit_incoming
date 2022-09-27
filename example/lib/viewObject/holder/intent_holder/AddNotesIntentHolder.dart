/*
 * *
 *  * Created by Kedar on 7/14/21 1:58 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:58 PM
 *
 */

import "package:flutter/cupertino.dart";

class AddNotesIntentHolder {
  const AddNotesIntentHolder({
    required this.clientId,
    required this.number,
    required this.channelId,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  final String? clientId;
  final String number;
  final String? channelId;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
}
