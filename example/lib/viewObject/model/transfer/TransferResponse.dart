import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/transfer/TransferResponseData.dart";

class TransferResponse extends Object<TransferResponse> {
  TransferResponse({
    this.transferResponseData,
  });

  TransferResponseData? transferResponseData;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  TransferResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransferResponse(
        transferResponseData:
            TransferResponseData().fromMap(dynamicData["warmTransfer"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TransferResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["warmTransfer"] =
          TransferResponseData().toMap(object.transferResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransferResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<TransferResponse> voiceTokenResponseList = <TransferResponse>[];
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
          dynamicList.add(toMap(data as TransferResponse));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
