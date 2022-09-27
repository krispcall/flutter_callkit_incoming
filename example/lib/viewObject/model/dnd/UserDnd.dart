import "package:mvp/viewObject/common/Object.dart";

class UserDnd extends Object<UserDnd> {
  String? title;
  int? time;
  bool? status;
  int? endTime;

  UserDnd({this.title, this.time, this.status, this.endTime});

  @override
  UserDnd? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserDnd(
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        time: dynamicData["time"] == null ? null : dynamicData["time"] as int,
        status: dynamicData["status"] == null
            ? null
            : dynamicData["status"] as bool,
        endTime: dynamicData["endTime"] == null
            ? null
            : dynamicData["endTime"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["title"] = object.title;
      data["time"] = object.time;
      data["status"] = object.status;
      data["endTime"] = object.endTime;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserDnd>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserDnd> psAppVersionList = <UserDnd>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          psAppVersionList.add(fromMap(json)!);
        }
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<UserDnd>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserDnd data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  String getPrimaryKey() {
    // TODO: implement getPrimaryKey
    throw UnimplementedError();
  }
}
