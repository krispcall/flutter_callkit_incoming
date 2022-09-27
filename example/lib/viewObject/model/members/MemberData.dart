import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";

class MemberData extends MapObject<MemberData> {
  List<MemberEdges>? memberEdges;
  PageInfo? pageInfo;
  String? id;

  MemberData({this.memberEdges, this.pageInfo, this.id});

  @override
  MemberData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberData(
        memberEdges: MemberEdges().fromMapList(dynamicData["edges"] == null
            ? null
            : dynamicData["edges"] as List<dynamic>),
        pageInfo: PageInfo().fromMap(dynamicData["pageInfo"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  List<MemberData>? fromMapList(List? dynamicDataList) {
    final List<MemberData> data = <MemberData>[];

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
  Map<String, dynamic>? toMap(MemberData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["edges"] = MemberEdges().toMapList(object.memberEdges);
      data["pageInfo"] = PageInfo().toMap(object.pageInfo);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<MemberData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<MemberData>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamList = <String>[];
    if (mapList != null) {
      for (final dynamic clientInfo in mapList) {
        if (MemberData().toMap(clientInfo as MemberData)!["$key"] == value) {
          filterParamList.add(clientInfo.id as String);
        }
      }
    }
    return filterParamList;
  }
}
