import "package:mvp/viewObject/common/Object.dart";

class AgentInfo extends Object<AgentInfo> {
  AgentInfo({this.agentId, this.firstname, this.lastname, this.profilePicture});

  String? agentId;
  String? firstname;
  String? lastname;
  String? profilePicture;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AgentInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AgentInfo(
          agentId: dynamicData["agentId"] == null
              ? null
              : dynamicData["agentId"] as String,
          firstname: dynamicData["firstname"] == null
              ? null
              : dynamicData["firstname"] as String,
          lastname: dynamicData["lastname"] == null
              ? null
              : dynamicData["lastname"] as String,
          profilePicture: dynamicData["profilePicture"] == null
              ? null
              : dynamicData["profilePicture"] as String);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AgentInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["agentId"] = object.agentId;
      data["firstname"] = object.firstname;
      data["lastname"] = object.lastname;
      data["profilePicture"] = object.profilePicture;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AgentInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AgentInfo> basketList = <AgentInfo>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<AgentInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AgentInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
