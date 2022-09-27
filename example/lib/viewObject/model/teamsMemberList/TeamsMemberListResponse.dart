/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/teamsMemberList/TeamsMemberListResponseData.dart";

class TeamsMemberListResponse extends Object<TeamsMemberListResponse> {
  TeamsMemberListResponseData? memberListResponseData;

  TeamsMemberListResponse({this.memberListResponseData});

  @override
  String ?getPrimaryKey() {
    return "";
  }

  @override
  TeamsMemberListResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TeamsMemberListResponse(
        memberListResponseData: TeamsMemberListResponseData()
            .fromMap(dynamicData["teamMembersList"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TeamsMemberListResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["teamMembersList"] =
          TeamsMemberListResponseData().toMap(object.memberListResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TeamsMemberListResponse>? fromMapList(List? dynamicDataList) {
    final List<TeamsMemberListResponse> login = <TeamsMemberListResponse>[];

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
  List<Map<String, dynamic>>? toMapList(
      List<TeamsMemberListResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final TeamsMemberListResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
