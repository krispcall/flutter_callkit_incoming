/*
 * *
 *  * Created by Kedar on 9/20/21 9:11 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 9/20/21 9:00 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/newLeadSubscription/NewLeadCountData.dart";

class NewLeadCountSubscription extends Object<NewLeadCountSubscription> {
  NewLeadCountData? newLeadsCount;

  NewLeadCountSubscription({this.newLeadsCount});

  @override
  NewLeadCountSubscription? fromMap(dynamic dynamicData) {
    return NewLeadCountSubscription(
      newLeadsCount: dynamicData["newLeadsCount"] != null
          ? NewLeadCountData().fromMap(dynamicData["newLeadsCount"])
          : null,
    );
  }

  @override
  Map<String, dynamic>? toMap(NewLeadCountSubscription? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.newLeadsCount != null) {
      data["newLeadsCount"] = NewLeadCountData().toMap(object.newLeadsCount);
    }
    return data;
  }

  @override
  List<NewLeadCountSubscription>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NewLeadCountSubscription> basketList =
        <NewLeadCountSubscription>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<NewLeadCountSubscription>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NewLeadCountSubscription data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
