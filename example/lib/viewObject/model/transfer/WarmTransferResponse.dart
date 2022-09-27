import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/transfer/WarmTransferResponseData.dart";

class WarmTransferResponse extends Object<WarmTransferResponse> {
  WarmTransferResponse({
    this.warmTransferResponseData,
  });

  WarmTransferResponseData? warmTransferResponseData;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WarmTransferResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WarmTransferResponse(
        warmTransferResponseData:
            WarmTransferResponseData().fromMap(dynamicData["warmTransfer"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WarmTransferResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["coldTransfer"] =
          WarmTransferResponseData().toMap(object.warmTransferResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WarmTransferResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WarmTransferResponse> voiceTokenResponseList =
        <WarmTransferResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          voiceTokenResponseList.add(fromMap(json)!);
        }
      }
    }
    return voiceTokenResponseList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as WarmTransferResponse));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
