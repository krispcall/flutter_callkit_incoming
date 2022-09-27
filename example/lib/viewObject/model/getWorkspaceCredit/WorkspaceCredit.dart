import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class WorkspaceCreditResponse extends Object<WorkspaceCreditResponse> {
  WorkspaceCreditResponse({
    this.getWorkspaceCredit,
  });

  GetWorkspaceCreditResponseData? getWorkspaceCredit;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceCreditResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceCreditResponse(
        getWorkspaceCredit: GetWorkspaceCreditResponseData()
            .fromMap(dynamicData["getWorkspaceCredit"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceCreditResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["getWorkspaceCredit"] =
          GetWorkspaceCreditResponseData().toMap(object.getWorkspaceCredit);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceCreditResponse>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<WorkspaceCreditResponse>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}

class GetWorkspaceCreditResponseData
    extends Object<GetWorkspaceCreditResponseData> {
  GetWorkspaceCreditResponseData({
    this.status,
    this.currentCredit,
    this.error,
  });

  int? status;
  CurrentCredit? currentCredit;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  GetWorkspaceCreditResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return GetWorkspaceCreditResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        currentCredit: CurrentCredit().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(GetWorkspaceCreditResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = CurrentCredit().toMap(object.currentCredit);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<GetWorkspaceCreditResponseData>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<GetWorkspaceCreditResponseData>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}

class CurrentCredit extends Object<CurrentCredit> {
  CurrentCredit({
    this.currentCredit,
  });

  String? currentCredit;

  @override
  CurrentCredit? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CurrentCredit(
        currentCredit: dynamicData["currentCredit"].toString(),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CurrentCredit? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["currentCredit"] = object.currentCredit;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CurrentCredit>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  String getPrimaryKey() {
    // TODO: implement getPrimaryKey
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<CurrentCredit>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
