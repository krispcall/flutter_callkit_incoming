import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPermissions/ContactsScreenBodyUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/ContactsScreenHeaderUserPermissions.dart";

class ContactsScreenUserPermissions
    extends Object<ContactsScreenUserPermissions> {
  final ContactScreenHeaderUserPermissions? contactScreenHeaderUserPermissions;
  final ContactScreenBodyUserPermissions? contactScreenBodyUserPermissions;

  ContactsScreenUserPermissions(
      {this.contactScreenHeaderUserPermissions,
      this.contactScreenBodyUserPermissions});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  ContactsScreenUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ContactsScreenUserPermissions(
        contactScreenHeaderUserPermissions:
            ContactScreenHeaderUserPermissions().fromMap(dynamicData["header"]),
        contactScreenBodyUserPermissions:
            ContactScreenBodyUserPermissions().fromMap(dynamicData["body"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ContactsScreenUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["header"] = ContactScreenHeaderUserPermissions()
          .toMap(object.contactScreenHeaderUserPermissions);
      data["body"] = ContactScreenBodyUserPermissions()
          .toMap(object.contactScreenBodyUserPermissions);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ContactsScreenUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ContactsScreenUserPermissions> listMessages =
        <ContactsScreenUserPermissions>[];

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
          dynamicList.add(toMap(data as ContactsScreenUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
