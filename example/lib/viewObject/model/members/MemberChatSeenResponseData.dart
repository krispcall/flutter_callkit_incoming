import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/members/MemberChatData.dart";

class MemberChatSeenResponseData extends Object<MemberChatSeenResponseData> {
  MemberChatSeenResponseData({
    this.status,
    this.memberData,
    this.error,
  });

  int? status;
  MemberChatData? memberData;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MemberChatSeenResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberChatSeenResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        memberData: MemberChatData().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberChatSeenResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = MemberChatData().toMap(object.memberData);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberChatSeenResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<MemberChatSeenResponseData> login =
        <MemberChatSeenResponseData>[];

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
  List<Map<String, dynamic>>? toMapList(
      List<MemberChatSeenResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberChatSeenResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
