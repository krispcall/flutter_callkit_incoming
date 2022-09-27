import "package:mvp/viewObject/common/MapObject.dart";
import "package:quiver/core.dart";

class UserNotificationSetting extends MapObject<UserNotificationSetting> {
  final String? id;
  final String? version;
  final String? platform;
  final String? fcmToken;
  final bool? callMessages;
  final bool? newLeads;
  final bool? flashTaskbar;

  UserNotificationSetting(
      {this.id,
      this.version,
      this.platform,
      this.fcmToken,
      this.callMessages,
      this.newLeads,
      this.flashTaskbar});

  @override
  bool operator ==(dynamic other) =>
      other is UserNotificationSetting && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  UserNotificationSetting? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserNotificationSetting(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        version: dynamicData["version"] == null
            ? null
            : dynamicData["version"] as String,
        platform: dynamicData["platform"] == null
            ? null
            : dynamicData["platform"] as String,
        fcmToken: dynamicData["fcmToken"] == null
            ? null
            : dynamicData["fcmToken"] as String,
        callMessages: dynamicData["callMessages"] == null
            ? null
            : dynamicData["callMessages"] as bool,
        newLeads: dynamicData["newLeads"] == null
            ? null
            : dynamicData["newLeads"] as bool,
        flashTaskbar: dynamicData["flashTaskbar"] == null
            ? null
            : dynamicData["flashTaskbar"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["version"] = object.agentProfilePicture;
      data["platform"] = object.clientNumber;
      data["fcmToken"] = object.channelNumber;
      data["callMessages"] = object.clientCountry;
      data["newLeads"] = object.clientProfilePicture;
      data["flashTaskbar"] = object.channelCountry;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserNotificationSetting>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserNotificationSetting> listMessages =
        <UserNotificationSetting>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data)!);
        }
      }
    }
    return dynamicList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
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
        if (UserNotificationSetting().toMap(clientInfo)!["$key"] == value) {
          if (clientInfo != null) {
            filterParamList.add(clientInfo.id as String);
          }
        }
      }
    }
    return filterParamList;
  }
}
