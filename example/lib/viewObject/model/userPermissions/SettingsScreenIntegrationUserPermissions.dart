import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenIntegrationUserPermissions
    extends Object<SettingsScreenIntegrationUserPermissions> {
  final bool? viewEnabled;
  final bool? viewOtherIntegration;

  SettingsScreenIntegrationUserPermissions(
      {this.viewEnabled, this.viewOtherIntegration});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenIntegrationUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenIntegrationUserPermissions(
        viewEnabled: dynamicData["view_enabled"] == null
            ? null
            : dynamicData["view_enabled"] as bool,
        viewOtherIntegration: dynamicData["view_other_integration"] == null
            ? null
            : dynamicData["view_other_integration"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(
      SettingsScreenIntegrationUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["view_enabled"] = object.viewEnabled;
      data["view_other_integration"] = object.viewOtherIntegration;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenIntegrationUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenIntegrationUserPermissions> listMessages =
        <SettingsScreenIntegrationUserPermissions>[];

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
              .add(toMap(data as SettingsScreenIntegrationUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
