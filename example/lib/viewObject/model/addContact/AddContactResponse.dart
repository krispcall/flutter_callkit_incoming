import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/addContact/AddContactResponseData.dart";

class AddContactResponse extends Object<AddContactResponse> {
  AddContactResponse({
    this.addContactResponseData,
  });

  AddContactResponseData? addContactResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddContactResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddContactResponse(
        addContactResponseData:
            AddContactResponseData().fromMap(dynamicData["addContact"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddContactResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["addContact"] =
          AddContactResponseData().toMap(object.addContactResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddContactResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddContactResponse> data = <AddContactResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<AddContactResponse> ?objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddContactResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
