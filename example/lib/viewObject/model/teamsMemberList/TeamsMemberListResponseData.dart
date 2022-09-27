import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/members/MemberData.dart";

class TeamsMemberListResponseData extends Object<TeamsMemberListResponseData> {
  TeamsMemberListResponseData({
    this.status,
    this.memberData,
    this.error,
  });

  int? status;
  MemberData? memberData;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  TeamsMemberListResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TeamsMemberListResponseData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        memberData: MemberData().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TeamsMemberListResponseData ?object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = MemberData().toMap(object.memberData);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TeamsMemberListResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<TeamsMemberListResponseData> login =
        <TeamsMemberListResponseData>[];

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
      List<TeamsMemberListResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final TeamsMemberListResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
