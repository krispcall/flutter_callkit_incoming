import "package:azlistview/azlistview.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/members/Members.dart";

class MemberEdges extends Object<MemberEdges> implements ISuspensionBean {
  String? cursor;
  String? teamId;
  Members? members;
  String? tagIndex;
  String? namePinyin;
  bool isChecked = false;

  MemberEdges({this.cursor, this.members, this.teamId});

  @override
  MemberEdges? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberEdges(
        cursor: dynamicData["cursor"] == null
            ? null
            : dynamicData["cursor"] as String,
        teamId: dynamicData["teamId"] == null
            ? null
            : dynamicData["teamId"] as String,
        members: Members().fromMap(dynamicData["node"]),
      );
    } else {
      return null;
    }
  }

  @override
  List<MemberEdges>? fromMapList(List? dynamicDataList) {
    final List<MemberEdges> data = <MemberEdges>[];

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
    return "id";
  }

  @override
  Map<String, dynamic>? toMap(MemberEdges? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["cursor"] = object.cursor;
      data["teamId"] = object.teamId;
      data["node"] = Members().toMap(object.members!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<MemberEdges>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberEdges data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  bool isShowSuspension = false;
}
