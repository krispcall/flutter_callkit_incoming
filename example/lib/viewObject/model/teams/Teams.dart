/*
 * *
 *  * Created by Kedar on 7/30/21 9:41 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:41 AM
 *  
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/teams/Members.dart";

class Teams extends Object<Teams> {
  Teams({
    this.id,
    this.workspaceId,
    this.title,
    this.name,
    this.total,
    this.avatar,
    this.members,
  });

  String? id;
  String? workspaceId;
  String? name;
  String? title;
  int? total;
  String? avatar;
  List<Members>? members;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  Teams? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Teams(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        workspaceId: dynamicData["workspaceId"] == null
            ? null
            : dynamicData["workspaceId"] as String,
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        total:
            dynamicData["total"] == null ? null : dynamicData["total"] as int,
        avatar: dynamicData["avatar"] == null
            ? null
            : dynamicData["avatar"] as String,
        members:
            Members().fromMapList(dynamicData["teamMembers"] as List<dynamic>),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Teams? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["workspaceId"] = object.workspaceId;
      data["title"] = object.title;
      data["name"] = object.name;
      data["total"] = object.total;
      data["avatar"] = object.avatar;
      data["teamMembers"] = Members().toMapList(object.members);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Teams>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Teams> userData = <Teams>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData)!);
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Teams>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Teams data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
