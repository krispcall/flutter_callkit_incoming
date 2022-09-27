/*
 * *
 *  * Created by Kedar on 8/2/21 10:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 10:56 AM
 *  
 */
import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class Plan extends Object<Plan> {
  Plan({this.id, this.title, this.rate});

  String? id;
  String? title;
  double? rate;

  @override
  bool operator ==(dynamic other) => other is Plan && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Plan? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Plan(
          id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
          title: dynamicData["title"] == null
              ? null
              : dynamicData["title"] as String,
          rate: dynamicData["rate"] == null
              ? null
              : dynamicData["rate"] as double);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Plan? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["title"] = object.title;
      data["rate"] = object.rate;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Plan>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Plan> workSpace = <Plan>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          workSpace.add(fromMap(dynamicData)!);
        }
      }
    }
    return workSpace;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Plan>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Plan data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
