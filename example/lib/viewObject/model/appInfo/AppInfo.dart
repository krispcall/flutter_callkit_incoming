import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/appInfo/AppInfoData.dart";

class AppInfo extends Object<AppInfo> {
  AppInfo({
    this.appRegisterInfo,
  });

  AppInfoData? appRegisterInfo;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AppInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AppInfo(
        appRegisterInfo: AppInfoData().fromMap(dynamicData["appRegisterInfo"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AppInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["appRegisterInfo"] = AppInfoData().toMap(object.appRegisterInfo!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AppInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AppInfo> psAppInfoList = <AppInfo>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json)!);
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as AppInfo));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
