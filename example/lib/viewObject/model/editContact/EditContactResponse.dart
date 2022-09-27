import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/editContact/EditContactResponseData.dart";

class EditContactResponse extends Object<EditContactResponse> {
  EditContactResponse({
    this.editContactResponseData,
  });

  EditContactResponseData? editContactResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  EditContactResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditContactResponse(
        editContactResponseData:
            EditContactResponseData().fromMap(dynamicData["editContact"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(EditContactResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["editContact"] =
          EditContactResponseData().toMap(object.editContactResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<EditContactResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<EditContactResponse> data = <EditContactResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<EditContactResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final EditContactResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
