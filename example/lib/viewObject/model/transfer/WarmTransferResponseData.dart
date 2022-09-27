import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class WarmTransferResponseData extends Object<WarmTransferResponseData> {
  WarmTransferResponseData({
    this.status,
    this.transfer,
    this.error,
  });

  int? status;
  TransferStatus? transfer;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WarmTransferResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WarmTransferResponseData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        transfer: TransferStatus().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WarmTransferResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = TransferStatus().toMap(object.transfer!);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WarmTransferResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WarmTransferResponseData> login = <WarmTransferResponseData>[];
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
      List<WarmTransferResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WarmTransferResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class TransferStatus extends Object<TransferStatus> {
  TransferStatus({
    this.conversationStatus,
  });

  String? conversationStatus;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  TransferStatus? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransferStatus(
        conversationStatus: dynamicData["conversationStatus"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TransferStatus? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["conversationStatus"] = object.conversationStatus;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransferStatus>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<TransferStatus> error = <TransferStatus>[];
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
  List<Map<String, dynamic>>? toMapList(List<TransferStatus>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final TransferStatus data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
