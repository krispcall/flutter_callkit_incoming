/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/members/MemberChatSeenResponseData.dart";

class MemberChatSeenResponse extends Object<MemberChatSeenResponse> {
  MemberChatSeenResponseData? memberChatSeenResponseData;

  MemberChatSeenResponse({this.memberChatSeenResponseData});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MemberChatSeenResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberChatSeenResponse(
        memberChatSeenResponseData: MemberChatSeenResponseData()
            .fromMap(dynamicData["editMemberChatSeen"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberChatSeenResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["editMemberChatSeen"] =
          MemberChatSeenResponseData().toMap(object.memberChatSeenResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberChatSeenResponse>? fromMapList(List? dynamicDataList) {
    final List<MemberChatSeenResponse> login = <MemberChatSeenResponse>[];

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
      List<MemberChatSeenResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberChatSeenResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
