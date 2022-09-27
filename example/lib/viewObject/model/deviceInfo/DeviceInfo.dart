import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class DeviceInfo extends Object<DeviceInfo> {
  DeviceInfo({
    this.id,
    this.platform,
    this.fcmToken,
    this.version,
  });

  String? id;
  String? platform;
  String? fcmToken;
  String? version;

  @override
  bool operator ==(dynamic other) => other is DeviceInfo && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  DeviceInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DeviceInfo(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        platform: dynamicData["platform"] == null
            ? null
            : dynamicData["platform"] as String,
        fcmToken: dynamicData["fcmToken"] == null
            ? null
            : dynamicData["fcmToken"] as String,
        version: dynamicData["version"] as String,
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
      data["platform"] = object.platform;
      data["fcmToken"] = object.fcmToken;
      data["version"] = object.version;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DeviceInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<DeviceInfo> psAppVersionList = <DeviceInfo>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          psAppVersionList.add(fromMap(json)!);
        }
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<DeviceInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DeviceInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
