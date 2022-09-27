import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class AreaCode extends Object<AreaCode> {
  AreaCode({
    this.stateCodeResponse,
  });

  StateCodeResponse? stateCodeResponse;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  AreaCode? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AreaCode(
          stateCodeResponse:
              StateCodeResponse().fromMap(dynamicData["allAreaCodes"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AreaCode? object) {
    if (object != null) {
      final Map<String, dynamic> data = {};
      data["allAreaCodes"] =
          StateCodeResponse().toMap(object.stateCodeResponse);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AreaCode>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AreaCode> data = <AreaCode>[];

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
  List<Map<String, dynamic>>? toMapList(List<AreaCode>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AreaCode data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class StateCodeResponse extends Object<StateCodeResponse> {
  StateCodeResponse({this.stateCodes, this.status, this.error});

  final List<StateCodes>? stateCodes;
  int? status;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  StateCodeResponse? fromJson(dynamic dynamicData) {
    if (dynamicData != null) {
      return StateCodeResponse(
        status: dynamicData["status"] as int,
        stateCodes:
            StateCodes().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["data"] = StateCodes().toMapList(stateCodes);
    data["error"] = ResponseError().toMap(error);
    return data;
  }

  @override
  StateCodeResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return StateCodeResponse(
        status: dynamicData["status"] as int,
        stateCodes:
            StateCodes().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(StateCodeResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = StateCodes().toMapList(object.stateCodes);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<StateCodeResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<StateCodeResponse> commentList = <StateCodeResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData)!);
        }
      }
    }
    return commentList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<StateCodeResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final StateCodeResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }
}

class StateCodes extends Object<StateCodes> {
  StateCodes({
    this.dialCode,
    this.country,
    this.alphaTwoCode,
    this.state,
    this.stateCenter,
    this.code,
    this.dialingCode,
    this.flagUrl,
  });

  final String? dialCode;
  final String? country;
  final String? alphaTwoCode;
  final String? state;
  final String? stateCenter;
  final String? code;
  final String? dialingCode;
  final String? flagUrl;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  StateCodes? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return StateCodes(
        dialCode: dynamicData["dialCode"] as String,
        country: dynamicData["country"] as String,
        alphaTwoCode: dynamicData["alphaTwoCode"] as String,
        state: dynamicData["state"] as String,
        stateCenter: dynamicData["stateCenter"] as String,
        code: dynamicData["code"] as String,
        dialingCode: dynamicData["dialingCode"] as String,
        flagUrl: dynamicData["flagUrl"] as String,
      );
    } else {
      return null;
    }
  }

  StateCodes? fromJson(dynamic dynamicData) {
    if (dynamicData != null) {
      return StateCodes(
        dialCode: dynamicData["dialCode"] as String,
        country: dynamicData["country"] as String,
        alphaTwoCode: dynamicData["alphaTwoCode"] as String,
        state: dynamicData["state"] as String,
        stateCenter: dynamicData["stateCenter"] as String,
        code: dynamicData["code"] as String,
        dialingCode: dynamicData["dialingCode"] as String,
        flagUrl: dynamicData["flagUrl"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(StateCodes? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["dialCode"] = object.dialCode;
      data["country"] = object.country;
      data["alphaTwoCode"] = object.alphaTwoCode;
      data["state"] = object.state;
      data["stateCenter"] = object.stateCenter;
      data["code"] = object.code;
      data["dialingCode"] = object.dialingCode;
      data["flagUrl"] = object.flagUrl;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["dialCode"] = dialCode;
    data["country"] = country;
    data["alphaTwoCode"] = alphaTwoCode;
    data["state"] = state;
    data["stateCenter"] = stateCenter;
    data["code"] = code;
    data["dialingCode"] = dialingCode;
    data["flagUrl"] = flagUrl;
    return data;
  }

  @override
  List<StateCodes>? fromMapList(dynamic dynamicDataList) {
    final List<StateCodes> commentList = <StateCodes>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData)!);
        }
      }
    }
    return commentList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<StateCodes>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final StateCodes data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }
}
