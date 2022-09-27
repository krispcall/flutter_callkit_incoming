import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class AllContactResponseData extends Object<AllContactResponseData> {
  AllContactResponseData({
    this.status,
    this.contactResponseData,
    this.error,
  });

  int? status;
  List<Contacts>? contactResponseData;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllContactResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllContactResponseData(
        status: dynamicData["status"] as int,
        contactResponseData: Contacts().fromMapList(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllContactResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Contacts().toMapList(object.contactResponseData);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllContactResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllContactResponseData> login = <AllContactResponseData>[];
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
      List<AllContactResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllContactResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
