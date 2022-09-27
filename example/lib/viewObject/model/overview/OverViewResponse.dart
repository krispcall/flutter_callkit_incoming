/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/overview/OverviewResponseData.dart";

class OverviewResponse extends Object<OverviewResponse> {
  OverViewResponseData? data;

  OverviewResponse({this.data});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  OverviewResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return OverviewResponse(
        data: OverViewResponseData().fromMap(dynamicData["planOverview"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(OverviewResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["planOverview"] = OverViewResponseData().toMap(object.data!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OverviewResponse>? fromMapList(List? dynamicDataList) {
    final List<OverviewResponse> login = <OverviewResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<OverviewResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final OverviewResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
