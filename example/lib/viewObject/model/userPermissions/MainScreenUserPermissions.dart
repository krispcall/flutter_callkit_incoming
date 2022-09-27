import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPermissions/MainScreenNavigationUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/MainScreenWorkspaceUserPermissions.dart";

class MainScreenUserPermissions extends Object<MainScreenUserPermissions> {
  final MainScreenWorkspaceUserPermissions? mainScreenWorkspaceUserPermissions;
  final MainScreenNavigationUserPermissions? mainScreenNavigationUserPermissions;

  MainScreenUserPermissions(
      {this.mainScreenWorkspaceUserPermissions,
      this.mainScreenNavigationUserPermissions});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MainScreenUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MainScreenUserPermissions(
        mainScreenWorkspaceUserPermissions: MainScreenWorkspaceUserPermissions()
            .fromMap(dynamicData["workspace"]),
        mainScreenNavigationUserPermissions:
            MainScreenNavigationUserPermissions()
                .fromMap(dynamicData["navigation"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MainScreenUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["workspace"] = MainScreenWorkspaceUserPermissions()
          .toMap(object.mainScreenWorkspaceUserPermissions!);
      data["navigation"] = MainScreenNavigationUserPermissions()
          .toMap(object.mainScreenNavigationUserPermissions);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MainScreenUserPermissions>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MainScreenUserPermissions> listMessages =
        <MainScreenUserPermissions>[];

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
          dynamicList.add(toMap(data as MainScreenUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
