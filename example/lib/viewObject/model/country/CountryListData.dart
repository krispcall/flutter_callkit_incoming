import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CountryListData extends Object<CountryListData> {
  CountryListData({
    this.status,
    this.countryCode,
    this.error,
  });

  int? status;
  List<CountryCode>? countryCode;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CountryListData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CountryListData(
        status: dynamicData["status"] as int,
        countryCode:
            CountryCode().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CountryListData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = CountryCode().toMapList(object.countryCode);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CountryListData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CountryListData> login = <CountryListData>[];

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
  List<Map<String, dynamic>>? toMapList(List<CountryListData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CountryListData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
