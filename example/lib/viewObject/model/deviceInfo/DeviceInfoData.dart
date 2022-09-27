import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/deviceInfo/DeviceInfo.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class DeviceInfoData extends Object<DeviceInfoData> {
  DeviceInfoData({
    this.status,
    this.deviceInfo,
    this.error,
  });

  int? status;
  DeviceInfo? deviceInfo;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  DeviceInfoData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DeviceInfoData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        deviceInfo: DeviceInfo().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(DeviceInfoData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = DeviceInfo().toMap(object.deviceInfo);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DeviceInfoData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<DeviceInfoData> login = <DeviceInfoData>[];
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
  List<Map<String, dynamic>>? toMapList(List<DeviceInfoData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DeviceInfoData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
