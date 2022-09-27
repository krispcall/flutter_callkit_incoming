import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class TransferResponseData extends Object<TransferResponseData> {
  TransferResponseData({
    this.status,
    this.transferStatus,
    this.error,
  });

  int? status;
  TransferStatus? transferStatus;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  TransferResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransferResponseData(
          status: dynamicData["status"] == null
              ? null
              : dynamicData["status"] as int,
          transferStatus: dynamicData["data"] == null
              ? null
              : TransferStatus().fromMap(dynamicData["data"]),
          error: ResponseError().fromMap(dynamicData["error"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TransferResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = object.transferStatus;
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransferResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<TransferResponseData> login = <TransferResponseData>[];
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
      List<TransferResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final TransferResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class TransferStatus extends Object<TransferStatus> {
  TransferStatus({
    this.transfer,
  });

  String? transfer;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  TransferStatus? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return TransferStatus(
        transfer: dynamicData["conversationStatus"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(TransferStatus? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["conversationStatus"] = object.transfer;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<TransferStatus>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<TransferStatus> data = <TransferStatus>[];
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
