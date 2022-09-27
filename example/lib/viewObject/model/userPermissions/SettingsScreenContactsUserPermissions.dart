import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenContactsUserPermissions
    extends Object<SettingsScreenContactsUserPermissions> {
  final bool? addNewIntegration;
  final bool? integrationGoogle;
  final bool? integrationPipeDrive;
  final bool? csvImport;
  final bool? deleteAllContacts;

  SettingsScreenContactsUserPermissions(
      {this.addNewIntegration,
      this.integrationGoogle,
      this.integrationPipeDrive,
      this.csvImport,
      this.deleteAllContacts});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenContactsUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenContactsUserPermissions(
        addNewIntegration: dynamicData["add_new_integration"] == null
            ? null
            : dynamicData["add_new_integration"] as bool,
        integrationGoogle: dynamicData["integration_google"] == null
            ? null
            : dynamicData["integration_google"] as bool,
        integrationPipeDrive: dynamicData["integration_pipedrive"] == null
            ? null
            : dynamicData["integration_pipedrive"] as bool,
        csvImport: dynamicData["csv_import"] == null
            ? null
            : dynamicData["csv_import"] as bool,
        deleteAllContacts: dynamicData["delete_all_contacts"] == null
            ? null
            : dynamicData["delete_all_contacts"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenContactsUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["add_new_integration"] = object.addNewIntegration;
      data["integration_google"] = object.integrationGoogle;
      data["integration_pipedrive"] = object.integrationPipeDrive;
      data["csv_import"] = object.csvImport;
      data["delete_all_contacts"] = object.deleteAllContacts;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenContactsUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenContactsUserPermissions> listMessages =
        <SettingsScreenContactsUserPermissions>[];

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
          dynamicList
              .add(toMap(data as SettingsScreenContactsUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
