import "package:mvp/viewObject/common/Object.dart";

class ChannelDnd extends Object<ChannelDnd> {
  String? title;
  int? time;
  bool? status;
  int? endTime;

  ChannelDnd({this.title, this.time, this.status, this.endTime});

  @override
  ChannelDnd? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelDnd(
          title: dynamicData["title"] == null
              ? null
              : dynamicData["title"] as String,
          time: dynamicData["time"] == null ? null : dynamicData["time"] as int,
          status: dynamicData["status"] == null
              ? null
              : dynamicData["status"] as bool,
          endTime: dynamicData["endTime"] == null
              ? null
              : dynamicData["endTime"] as int);
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
  List<ChannelDnd>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ChannelDnd> psAppVersionList = <ChannelDnd>[];
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
  List<Map<String, dynamic>>? toMapList(List<ChannelDnd>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChannelDnd data in objectList) {
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
