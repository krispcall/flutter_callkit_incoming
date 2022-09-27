/*
 * *
 *  * Created by Kedar on 7/29/21 9:15 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:15 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/last_contacted/LastContactedData.dart";

class LastContactedResponse extends Object<LastContactedResponse> {
  LastContactedData? data;

  LastContactedResponse({this.data});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LastContactedResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LastContactedResponse(
        data: LastContactedData().fromMap(dynamicData["lastContactedTime"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LastContactedResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["inviteMember"] = LastContactedData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LastContactedResponse>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<LastContactedResponse>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
