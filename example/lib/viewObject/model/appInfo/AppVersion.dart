import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class AppVersion extends Object<AppVersion> {
  AppVersion(
      {this.versionNo,
      this.versionForceUpdate,
      this.versionNeedClearData,
      this.appType,
      this.modifiedOn,
      this.isReleased,
      this.appURL});

  String? versionNo;
  bool? versionForceUpdate;
  bool? versionNeedClearData;
  String? appType;
  String? modifiedOn;
  bool? isReleased;
  String? appURL;

  @override
  bool operator ==(dynamic other) =>
      other is AppVersion && versionNo == other.versionNo;

  @override
  int get hashCode => hash2(versionNo.hashCode, versionNo.hashCode);

  @override
  String getPrimaryKey() {
    return versionNo!;
  }

  @override
  AppVersion? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AppVersion(
        versionNo: dynamicData["versionNo"] == null
            ? null
            : dynamicData["versionNo"] as String,
        versionForceUpdate: dynamicData["versionForceUpdate"] == null
            ? null
            : dynamicData["versionForceUpdate"] as bool,
        versionNeedClearData: dynamicData["versionNeedClearData"] == null
            ? null
            : dynamicData["versionNeedClearData"] as bool,
        appType: dynamicData["appType"] == null
            ? null
            : dynamicData["appType"] as String,
        modifiedOn: dynamicData["modifiedOn"] == null
            ? null
            : dynamicData["modifiedOn"] as String,
        isReleased: dynamicData["isReleased"] == null
            ? null
            : dynamicData["isReleased"] as bool,
        appURL: dynamicData["appURL"] == null
            ? null
            : dynamicData["appURL"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AppVersion? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["versionNo"] = object.versionNo;
      data["versionForceUpdate"] = object.versionForceUpdate;
      data["versionNeedClearData"] = object.versionNeedClearData;
      data["appType"] = object.appType;
      data["modifiedOn"] = object.modifiedOn;
      data["isReleased"] = object.isReleased;
      data["appURL"] = object.appURL;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AppVersion>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AppVersion> psAppVersionList = <AppVersion>[];
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
  List<Map<String, dynamic>>? toMapList(List<AppVersion>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AppVersion data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
