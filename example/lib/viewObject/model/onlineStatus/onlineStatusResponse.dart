/*
 * *
 *  * Created by Kedar on 7/29/21 9:15 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:15 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/onlineStatus/onlineStatusResponseData.dart";

class OnlineStatusResponse extends Object<OnlineStatusResponse> {
  OnlineStatusResponseData? data;

  OnlineStatusResponse({this.data});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  OnlineStatusResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return OnlineStatusResponse(
        data: OnlineStatusResponseData()
            .fromMap(dynamicData["updateOnlineStatus"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(OnlineStatusResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["updateOnlineStatus"] =
          OnlineStatusResponseData().toMap(object.data!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OnlineStatusResponse>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<OnlineStatusResponse>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
