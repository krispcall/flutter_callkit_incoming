/*
 * *
 *  * Created by Kedar on 7/21/21 11:29 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/21/21 11:29 AM
 *  
 */

import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestParamHolder.dart";

class AddNoteToContactRequestHolder
    extends Holder<AddNoteToContactRequestHolder> {
  AddNoteToContactRequestHolder({required this.clientId, required this.data});

  final String? clientId;
  final AddNoteToContactRequestParamHolder data;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["clientId"] = clientId;
    map["data"] = data.toMap();
    return map;
  }

  @override
  AddNoteToContactRequestHolder fromMap(dynamic dynamicData) {
    return AddNoteToContactRequestHolder(
      clientId: dynamicData["clientId"] as String,
      data: AddNoteToContactRequestParamHolder().fromMap(dynamicData["data"]),
    );
  }
}
