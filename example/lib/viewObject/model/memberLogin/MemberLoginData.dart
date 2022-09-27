import "package:mvp/viewObject/common/Object.dart";

class MemberLoginData extends Object<MemberLoginData> {
  MemberLoginData({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MemberLoginData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberLoginData(
        accessToken: dynamicData["accessToken"] == null
            ? null
            : dynamicData["accessToken"] as String,
        refreshToken: dynamicData["refreshToken"] == null
            ? null
            : dynamicData["refreshToken"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberLoginData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["accessToken"] = object.accessToken;
      data["refreshToken"] = object.refreshToken;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberLoginData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MemberLoginData> login = <MemberLoginData>[];

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
  List<Map<String, dynamic>>? toMapList(List<MemberLoginData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberLoginData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
