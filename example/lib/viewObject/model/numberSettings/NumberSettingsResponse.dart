import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettingsResponseData.dart";

class NumberSettingsResponse extends Object<NumberSettingsResponse> {
  NumberSettingsResponseData? numberSettingsResponseData;

  NumberSettingsResponse({this.numberSettingsResponseData});

  @override
  NumberSettingsResponse? fromMap(dynamic dynamic) {
    return NumberSettingsResponse(
        numberSettingsResponseData: dynamic["numberSettings"] != null
            ? NumberSettingsResponseData().fromMap(dynamic["numberSettings"])
            : null);
  }

  Map<String, dynamic>? toMap(NumberSettingsResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.numberSettingsResponseData != null) {
      data["numberSettings"] =
          NumberSettingsResponseData().toMap(object.numberSettingsResponseData!);
    }
    return data;
  }

  @override
  List<NumberSettingsResponse> ?fromMapList(List<dynamic>? dynamicDataList) {
    final List<NumberSettingsResponse> list = <NumberSettingsResponse>[];

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
      List<NumberSettingsResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as NumberSettingsResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
