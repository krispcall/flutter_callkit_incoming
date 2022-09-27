import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";

class NumberSettingsResponseData extends Object<NumberSettingsResponseData> {
  NumberSettingsResponseData({
    this.status,
    this.numberSettings,
    this.error,
  });

  int? status;
  NumberSettings? numberSettings;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  NumberSettingsResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NumberSettingsResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        numberSettings: NumberSettings().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NumberSettingsResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = NumberSettings().toMap(object.numberSettings);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NumberSettingsResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<NumberSettingsResponseData> login =
        <NumberSettingsResponseData>[];
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
      List<NumberSettingsResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NumberSettingsResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
