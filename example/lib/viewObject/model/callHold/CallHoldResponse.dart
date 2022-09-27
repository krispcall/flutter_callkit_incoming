import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/callHold/CallHoldResponseData.dart";

class CallHoldResponse extends Object<CallHoldResponse> {
  CallHoldResponse({
    this.callHoldResponseData,
  });

  CallHoldResponseData? callHoldResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CallHoldResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallHoldResponse(
        callHoldResponseData:
            CallHoldResponseData().fromMap(dynamicData["callHold"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CallHoldResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["callHold"] =
          CallHoldResponseData().toMap(object.callHoldResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallHoldResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CallHoldResponse> login = <CallHoldResponse>[];
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
  List<Map<String, dynamic>>? toMapList(List<CallHoldResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CallHoldResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
