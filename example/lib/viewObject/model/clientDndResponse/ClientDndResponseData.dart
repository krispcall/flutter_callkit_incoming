import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class ClientDndResponseData extends Object<ClientDndResponseData> {
  ClientDndResponseData({
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
  ClientDndResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ClientDndResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        contacts: Contacts().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ClientDndResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Contacts().toMap(object.contacts);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ClientDndResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ClientDndResponseData> login = <ClientDndResponseData>[];
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
      List<ClientDndResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ClientDndResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
