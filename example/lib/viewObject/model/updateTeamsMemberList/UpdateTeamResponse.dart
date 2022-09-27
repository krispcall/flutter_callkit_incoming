import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";

class UpdateTeamResponse extends Object<UpdateTeamResponse> {
  UpdateTeamResponse({
    this.status,
    this.teams,
    this.error,
  });

  int? status;
  Teams? teams;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UpdateTeamResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UpdateTeamResponse(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        teams: Teams().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UpdateTeamResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Teams().toMap(object.teams);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UpdateTeamResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UpdateTeamResponse> login = <UpdateTeamResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<UpdateTeamResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UpdateTeamResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
