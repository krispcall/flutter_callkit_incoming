import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CheckDuplicateLogin extends Object<CheckDuplicateLogin> {
  CheckDuplicateLogin({
    this.clientDndResponseData,
  });

  CheckDuplicateLoginData? clientDndResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CheckDuplicateLogin? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CheckDuplicateLogin(
        clientDndResponseData: CheckDuplicateLoginData()
            .fromMap(dynamicData["checkDuplicateLogin"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CheckDuplicateLogin? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["checkDuplicateLogin"] =
          CheckDuplicateLoginData().toMap(object.clientDndResponseData);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CheckDuplicateLogin> ?fromMapList(List<dynamic>? dynamicDataList) {
    final List<CheckDuplicateLogin> data = <CheckDuplicateLogin>[];

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
  List<Map<String, dynamic>>? toMapList(List<CheckDuplicateLogin>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CheckDuplicateLogin data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class CheckDuplicateLoginData extends Object<CheckDuplicateLoginData> {
  int? status;
  DataResult? data;
  ResponseError ?error;

  CheckDuplicateLoginData({this.status, this.data, this.error});

  @override
  CheckDuplicateLoginData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CheckDuplicateLoginData(
        status: dynamicData["status"] as int,
        data: DataResult().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  List<CheckDuplicateLoginData> ?fromMapList(List ?dynamicDataList) {
    return null;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(CheckDuplicateLoginData ?object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = DataResult().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<CheckDuplicateLoginData> ?objectList) {
    return null;
  }
}

class DataResult extends Object<DataResult> {
  bool? success;

  DataResult({this.success});

  @override
  DataResult? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DataResult(
        success: dynamicData["success"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  List<DataResult>? fromMapList(List? dynamicDataList) {
    final List<DataResult> data = <DataResult>[];

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
  String getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(DataResult? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["success"] = object.success;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<DataResult>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DataResult data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
