import "package:mvp/viewObject/common/Object.dart";

class MainScreenWorkspaceUserPermissions
    extends Object<MainScreenWorkspaceUserPermissions> {
  final bool? viewSwitchWorkspace;
  final bool? createNewWorkspace;
  final bool? editProfile;

  MainScreenWorkspaceUserPermissions(
      {this.viewSwitchWorkspace, this.createNewWorkspace, this.editProfile});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  MainScreenWorkspaceUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MainScreenWorkspaceUserPermissions(
        viewSwitchWorkspace: dynamicData["view_switch_workspace"] == null
            ? null
            : dynamicData["view_switch_workspace"] as bool,
        createNewWorkspace: dynamicData["create_new_workspace"] == null
            ? null
            : dynamicData["create_new_workspace"] as bool,
        editProfile: dynamicData["edit_profile"] == null
            ? null
            : dynamicData["edit_profile"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MainScreenWorkspaceUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["view_switch_workspace"] = object.viewSwitchWorkspace;
      data["create_new_workspace"] = object.createNewWorkspace;
      data["edit_profile"] = object.editProfile;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MainScreenWorkspaceUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<MainScreenWorkspaceUserPermissions> listMessages =
        <MainScreenWorkspaceUserPermissions>[];

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
          dynamicList.add(toMap(data as MainScreenWorkspaceUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
