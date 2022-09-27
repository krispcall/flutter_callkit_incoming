/*
 * *
 *  * Created by Kedar on 7/24/21 12:13 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/24/21 12:13 PM
 *
 */

import "package:mvp/viewObject/common/Holder.dart" show Holder;

class AddNoteToContactRequestParamHolder
    extends Holder<AddNoteToContactRequestParamHolder> {
  AddNoteToContactRequestParamHolder({this.title, this.channelId});

  final String? title;
  final String? channelId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["title"] = title;
    map["channelId"] = channelId;

    return map;
  }

  @override
  AddNoteToContactRequestParamHolder fromMap(dynamic dynamicData) {
    return AddNoteToContactRequestParamHolder(
      title: dynamicData["title"] as String,
      channelId: dynamicData["channelId"] as String,
    );
  }
}
