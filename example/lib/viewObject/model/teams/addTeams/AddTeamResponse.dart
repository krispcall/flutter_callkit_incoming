/*
 * *
 *  * Created by Kedar on 7/30/21 8:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 8:56 AM
 *  
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/teams/addTeams/AddTeamData.dart";

class AddTeamResponse extends Object<AddTeamResponse> {
  AddTeamResponse({
    this.data,
  });

  AddTeamData? data;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  AddTeamResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddTeamResponse(
        data: AddTeamData().fromMap(dynamicData["addTeam"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddTeamResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["addTeam"] = AddTeamData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddTeamResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddTeamResponse> login = <AddTeamResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<AddTeamResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddTeamResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
