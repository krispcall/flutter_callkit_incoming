import "package:mvp/viewObject/common/Object.dart";

class ContactScreenHeaderUserPermissions
    extends Object<ContactScreenHeaderUserPermissions> {
  final bool? searchContact;
  final bool? addNewContact;
  final bool? csvImport;

  ContactScreenHeaderUserPermissions(
      {this.searchContact, this.addNewContact, this.csvImport});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  ContactScreenHeaderUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ContactScreenHeaderUserPermissions(
        searchContact:dynamicData["search_contact"] == null? null : dynamicData["search_contact"] as bool,
        addNewContact:dynamicData["add_new_contact"] == null? null : dynamicData["add_new_contact"] as bool,
        csvImport: dynamicData["import_csv"] == null? null :dynamicData["import_csv"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> ?toMap(ContactScreenHeaderUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["search_contact"] = object.searchContact;
      data["add_new_contact"] = object.addNewContact;
      data["import_csv"] = object.csvImport;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ContactScreenHeaderUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ContactScreenHeaderUserPermissions> listMessages =
        <ContactScreenHeaderUserPermissions>[];

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
          dynamicList.add(toMap(data as ContactScreenHeaderUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
