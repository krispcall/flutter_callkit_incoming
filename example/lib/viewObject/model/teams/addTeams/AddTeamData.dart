/*
 * *
 *  * Created by Kedar on 7/30/21 9:09 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 9:09 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";

class AddTeamData extends Object<AddTeamData> {
  AddTeamData({
    this.status,
    this.teams,
    this.error,
  });

  int? status;
  ResponseError? error;
  Teams? teams;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  AddTeamData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddTeamData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        teams: Teams().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddTeamData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Teams().toMap(object.teams!);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddTeamData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddTeamData> login = <AddTeamData>[];

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
  List<Map<String, dynamic>>? toMapList(List<AddTeamData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddTeamData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
