import "package:mvp/viewObject/common/Object.dart";

class NewLeadCountData extends Object<NewLeadCountData> {
  NewLeadCountData({
    this.event,
    this.message,
  });

  String? event;
  NewLeadCountMessage? message;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  NewLeadCountData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NewLeadCountData(
        event: dynamicData["event"] == null
            ? null
            : dynamicData["event"] as String,
        message: NewLeadCountMessage().fromMap(dynamicData["message"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NewLeadCountData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["event"] = object.event;
      data["message"] = NewLeadCountMessage().toMap(object.message!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NewLeadCountData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NewLeadCountData> login = <NewLeadCountData>[];
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
  List<Map<String, dynamic>>? toMapList(List<NewLeadCountData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NewLeadCountData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class NewLeadCountMessage extends Object<NewLeadCountMessage> {
  NewLeadCountMessage({
    this.count,
    this.data,
    this.channel,
  });

  int? count;
  int? data;
  String? channel;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  NewLeadCountMessage? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NewLeadCountMessage(
        count:
            dynamicData["count"] == null ? null : dynamicData["count"] as int,
        data: dynamicData["data"] == null ? null : dynamicData["data"] as int,
        channel: dynamicData["data"] == null
            ? null
            : dynamicData["channel"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NewLeadCountMessage? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["count"] = object.count;
      data["data"] = object.data;
      data["channel"] = object.channel;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NewLeadCountMessage>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NewLeadCountMessage> login = <NewLeadCountMessage>[];
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
  List<Map<String, dynamic>>? toMapList(List<NewLeadCountMessage>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NewLeadCountMessage data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
