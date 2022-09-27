/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/members/MembersResponseData.dart";

class MembersResponse extends Object<MembersResponse> {
  MemberResponseData? memberResponseData;

  MembersResponse({this.memberResponseData});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MembersResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MembersResponse(
        memberResponseData:
            MemberResponseData().fromMap(dynamicData["allWorkspaceMembers"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MembersResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["allWorkspaceMembers"] =
          MemberResponseData().toMap(object.memberResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MembersResponse>? fromMapList(List? dynamicDataList) {
    final List<MembersResponse> login = <MembersResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<MembersResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MembersResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
