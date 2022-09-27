import "package:mvp/viewObject/common/Object.dart";

class CallAccessToken extends Object<CallAccessToken> {
  CallAccessToken({this.callAccessToken, this.identity});
  String? callAccessToken;
  String? identity;
  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  CallAccessToken? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallAccessToken(
        callAccessToken: dynamicData["token"] == null
            ? null
            : dynamicData["token"] as String,
        identity: dynamicData["identity"] == null
            ? null
            : dynamicData["identity"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["token"] = object.callAccessToken;
      data["identity"] = object.identity;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallAccessToken>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CallAccessToken> psAppInfoList = <CallAccessToken>[];

    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json)!);
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
