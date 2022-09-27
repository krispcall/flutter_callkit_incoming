/*
 * *
 *  * Created by Kedar on 7/30/21 9:09 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:09 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/userDnd/Dnd.dart";

class DndData extends Object<DndData> {
  DndData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  ResponseError? error;
  Dnd? data;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  DndData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DndData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: Dnd().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(DndData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Dnd().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DndData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<DndData> login = <DndData>[];

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
  List<Map<String, dynamic>>? toMapList(List<DndData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DndData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
