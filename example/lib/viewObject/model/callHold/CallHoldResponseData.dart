import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CallHoldResponseData extends Object<CallHoldResponseData> {
  CallHoldResponseData({this.status, this.error, this.data});

  int? status;
  ResponseError? error;
  HoldCallData? data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CallHoldResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallHoldResponseData(
          status: dynamicData["status"] == null
              ? null
              : dynamicData["status"] as int,
          error: ResponseError().fromMap(dynamicData["error"]),
          data: HoldCallData().fromMap(dynamicData["data"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CallHoldResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["error"] = ResponseError().toMap(object.error);
      data["data"] = HoldCallData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallHoldResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CallHoldResponseData> login = <CallHoldResponseData>[];
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
      List<CallHoldResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CallHoldResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class HoldCallData extends Object<HoldCallData> {
  HoldCallData({
    this.message,
  });

  String? message;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  HoldCallData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return HoldCallData(
        message: dynamicData["message"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(HoldCallData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["message"] = object.message;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<HoldCallData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<HoldCallData> error = <HoldCallData>[];
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
  List<Map<String, dynamic>>? toMapList(List<HoldCallData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final HoldCallData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
