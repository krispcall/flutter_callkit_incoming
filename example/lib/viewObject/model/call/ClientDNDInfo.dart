/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/8/21 10:41 AM
 *  * Refactored by Joshan
 *
 */

import "package:mvp/viewObject/common/MapObject.dart";

class ClientDNDInfo extends MapObject<ClientDNDInfo> {
  ClientDNDInfo({this.dndDuration, this.dndEnabled, this.dndEndtime});

  int? dndDuration;
  bool? dndEnabled;
  int? dndEndtime;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ClientDNDInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ClientDNDInfo(
        dndDuration: dynamicData["dndDuration"] == null
            ? null
            : dynamicData["dndDuration"] as int,
        dndEnabled: dynamicData["dndEnabled"] == null
            ? null
            : dynamicData["dndEnabled"] as bool,
        dndEndtime: dynamicData["dndEndtime"] == null
            ? null
            : dynamicData["dndEndtime"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ClientDNDInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["dndDuration"] = object.dndDuration;
      data["dndEnabled"] = object.dndEnabled;
      data["dndEndtime"] = object.dndEndtime;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ClientDNDInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ClientDNDInfo> basketList = <ClientDNDInfo>[];
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
  List<Map<String, dynamic>>? toMapList(List<ClientDNDInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ClientDNDInfo data in objectList) {
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
        if (ClientDNDInfo().toMap(clientInfo as ClientDNDInfo)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.getPrimaryKey());
        }
      }
    }
    return filterParamList;
  }
}
