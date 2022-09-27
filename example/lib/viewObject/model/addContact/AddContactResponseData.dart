import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class AddContactResponseData extends Object<AddContactResponseData> {
  AddContactResponseData({
    this.status,
    this.contacts,
    this.error,
  });

  int? status;
  Contacts? contacts;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddContactResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddContactResponseData(
        status: dynamicData["status"] as int,
        contacts: Contacts().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddContactResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Contacts().toMap(object.contacts!);
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddContactResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddContactResponseData> login = <AddContactResponseData>[];
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
      List<AddContactResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddContactResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
