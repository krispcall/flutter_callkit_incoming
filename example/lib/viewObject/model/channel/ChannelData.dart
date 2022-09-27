/*
 * *
 *  * Created by Kedar on 7/20/21 2:29 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/20/21 2:29 PM
 *  
 */
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class ChannelData extends Object<ChannelData> {
  ChannelData({
    this.status,
    this.data,
    this.error,
    this.id,
  });

  int? status;
  List<WorkspaceChannel>? data;
  ResponseError? error;
  String? id;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChannelData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: WorkspaceChannel()
            .fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ChannelData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = WorkspaceChannel().toMapList(object.data);
      data["error"] = ResponseError().toMap(object.error);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ChannelData> login = <ChannelData>[];

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
  List<Map<String, dynamic>>? toMapList(List<ChannelData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChannelData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
