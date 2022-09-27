import "package:mvp/viewObject/common/Object.dart";

class MemberChatData extends Object<MemberChatData> {
  bool? success;

  MemberChatData({this.success});

  @override
  MemberChatData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberChatData(
        success: dynamicData["success"] == null
            ? null
            : dynamicData["success"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  List<MemberChatData>? fromMapList(List? dynamicDataList) {
    final List<MemberChatData> data = <MemberChatData>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(MemberChatData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["success"] = object.success;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<MemberChatData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberChatData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
