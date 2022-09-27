import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
/*
 * *
 *  * Created by Kedar on 6/29/21 9:12 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 9:12 AM
 *
 */

class SubscriptionWorkspaceChatDetailResponse
    extends Object<SubscriptionWorkspaceChatDetailResponse> {
  String? event;
  RecentConversationMemberNodes? message;

  SubscriptionWorkspaceChatDetailResponse({this.event, this.message});

  @override
  SubscriptionWorkspaceChatDetailResponse? fromMap(dynamic dynamic) {
    return SubscriptionWorkspaceChatDetailResponse(
      message: dynamic["message"] != null
          ? RecentConversationMemberNodes().fromMap(dynamic["message"])
          : null,
      event: dynamic["event"] as String,
    );
  }

  Map<String, dynamic>? toMap(SubscriptionWorkspaceChatDetailResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data["message"] = RecentConversationMemberNodes().toMap(object.message);
      data["event"] = object.event;
    }
    return data;
  }

  @override
  List<SubscriptionWorkspaceChatDetailResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SubscriptionWorkspaceChatDetailResponse> list =
        <SubscriptionWorkspaceChatDetailResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<SubscriptionWorkspaceChatDetailResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList
              .add(toMap(data as SubscriptionWorkspaceChatDetailResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
