/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/8/21 10:41 AM
 *  * Refactored by Joshan
 *
 */

import "package:audioplayers/audioplayers.dart";
import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";

class RecentConversationEdges extends MapObject<RecentConversationEdges> {
  RecentConversationEdges({
    this.cursor,
    this.channelId,
    this.conversationType,
    this.recentConversationNodes,
    this.id,
    this.check,
    this.isPlay = false,
    this.isPlaySeekFinish = false,
    this.advancePlayDefault = true,
    this.advancedPlayer,
    this.seekData = "0",
    this.seekDataTotal = "0",
    this.fromSub = false,
  });

  String? id;
  String? cursor;
  String? channelId;
  String? conversationType;
  RecentConversationNodes? recentConversationNodes;
  bool? check = false;
  bool? isPlaySeekFinish;

  bool? isPlay;
  bool? advancePlayDefault;
  String? seekData;
  String? seekDataTotal;
  AudioPlayer? advancedPlayer;
  bool? fromSub = false;

  @override
  String getPrimaryKey() {
    return cursor!;
  }

  @override
  RecentConversationEdges? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationEdges(
        cursor: dynamicData["cursor"] == null
            ? null
            : dynamicData["cursor"] as String,
        channelId: dynamicData["channelId"] == null
            ? null
            : dynamicData["channelId"] as String,
        conversationType:
            dynamicData["q"] == null ? null : dynamicData["q"] as String,
        recentConversationNodes:
            RecentConversationNodes().fromMap(dynamicData["node"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        check: false,
        fromSub: fromSub,
        advancedPlayer: advancedPlayer,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationEdges? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["cursor"] = object.cursor;
      data["channelId"] = object.channelId;
      data["q"] = object.conversationType;
      data["node"] = object.recentConversationNodes != null
          ? RecentConversationNodes().toMap(object.recentConversationNodes)
          : null;
      data["id"] = object.id;
      data["sorting"] = object.sorting;
      data["check"] = object.check;
      data["fromSub"] = object.fromSub;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationEdges>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversationEdges> basketList =
        <RecentConversationEdges>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<RecentConversationEdges>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationEdges data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.cursor as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<dynamic>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamList = <String>[];
    if (mapList != null) {
      for (final dynamic clientInfo in mapList) {
        if (RecentConversationEdges()
                .toMap(clientInfo as RecentConversationEdges)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.id as String);
        }
      }
    }
    return filterParamList;
  }
}
