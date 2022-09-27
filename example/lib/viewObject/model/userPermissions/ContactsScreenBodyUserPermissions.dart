import "package:mvp/viewObject/common/Object.dart";

class ContactScreenBodyUserPermissions
    extends Object<ContactScreenBodyUserPermissions> {
  late bool? tableView;

  ContactScreenBodyUserPermissions({this.tableView});

  @override
  String ?getPrimaryKey() {
    return "";
  }

  @override
  ContactScreenBodyUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ContactScreenBodyUserPermissions(
        tableView: dynamicData["table_view"] == null? null : dynamicData["table_view"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ContactScreenBodyUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["table_view"] = object.tableView;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ContactScreenBodyUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ContactScreenBodyUserPermissions> listMessages =
        <ContactScreenBodyUserPermissions>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as ContactScreenBodyUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
