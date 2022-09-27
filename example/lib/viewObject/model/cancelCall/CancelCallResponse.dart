import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/cancelCall/CancelCallResponseData.dart";

class CancelCallResponse extends Object<CancelCallResponse> {
  CancelCallResponse({
    this.callResponse,
  });

  CancelCallResponseData? callResponse;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CancelCallResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CancelCallResponse(
        callResponse:
            CancelCallResponseData().fromMap(dynamicData["rejectConversation"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CancelCallResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["rejectConversation"] =
          CancelCallResponseData().toMap(object.callResponse!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CancelCallResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CancelCallResponse> data = <CancelCallResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<CancelCallResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CancelCallResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
