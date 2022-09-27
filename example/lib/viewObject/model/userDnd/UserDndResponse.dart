import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userDnd/DndData.dart";

class UserDndResponse extends Object<UserDndResponse> {
  UserDndResponse({
    this.data,
  });

  DndData? data;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserDndResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserDndResponse(
        data: DndData().fromMap(dynamicData["setUserDND"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserDndResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["setUserDND"] = DndData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserDndResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserDndResponse> login = <UserDndResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<UserDndResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserDndResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
