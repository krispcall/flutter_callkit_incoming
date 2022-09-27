import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CallRatingResponse extends Object<CallRatingResponse> {
  CallRatingResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  ResourceSucceedPayloadData? data;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CallRatingResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallRatingResponse(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: ResourceSucceedPayloadData().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CallRatingResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = ResourceSucceedPayloadData().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallRatingResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CallRatingResponse> login = <CallRatingResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<CallRatingResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CallRatingResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class ResourceSucceedPayloadData extends Object<ResourceSucceedPayloadData> {
  ResourceSucceedPayloadData({
    this.success,
  });

  bool? success;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ResourceSucceedPayloadData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ResourceSucceedPayloadData(
        success: dynamicData["success"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ResourceSucceedPayloadData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["success"] = object.success;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ResourceSucceedPayloadData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ResourceSucceedPayloadData> error =
        <ResourceSucceedPayloadData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          error.add(fromMap(dynamicData)!);
        }
      }
    }
    return error;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<ResourceSucceedPayloadData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ResourceSucceedPayloadData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
