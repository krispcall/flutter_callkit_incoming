import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponseData.dart";

class AllContactResponse extends Object<AllContactResponse> {
  AllContactResponse({
    this.contactResponse,
    this.id,
  });

  AllContactResponseData? contactResponse;
  String? id;

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  AllContactResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllContactResponse(
        contactResponse:
            AllContactResponseData().fromMap(dynamicData["newContacts"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllContactResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["newContacts"] =
          AllContactResponseData().toMap(object.contactResponse!);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllContactResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllContactResponse> data = <AllContactResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<AllContactResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllContactResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
