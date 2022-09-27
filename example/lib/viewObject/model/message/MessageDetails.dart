import "package:mvp/viewObject/common/MapObject.dart";
import "package:quiver/core.dart";

class MessageDetails extends MapObject<MessageDetails> {
  MessageDetails({
    this.id,
    this.clientNumber,
    this.message,
    this.direction,
    this.date,
    this.timestamp,
    int? sorting,
  }) {
    super.sorting = sorting;
  }

  String? id;
  String? clientNumber;
  String? message;
  String? direction;
  String? date;
  String? timestamp;

  @override
  bool operator ==(dynamic other) => other is MessageDetails && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  MessageDetails? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MessageDetails(
        id: dynamicData["id"].toString(),
        clientNumber: dynamicData["client_number"] == null
            ? null
            : dynamicData["client_number"] as String,
        message:
            dynamicData["body"] == null ? null : dynamicData["body"] as String,
        direction: dynamicData["direction"] == null
            ? null
            : dynamicData["direction"] as String,
        date: dynamicData["date"].toString(),
        timestamp: dynamicData["timestamp"].toString(),
        sorting: dynamicData["sorting"] == null
            ? null
            : dynamicData["sorting"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["client_number"] = object.clientNumber;
      data["body"] = object.message;
      data["direction"] = object.direction;
      data["date"] = object.date;
      data["timestamp"] = object.timestamp;
      data["sorting"] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MessageDetails>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MessageDetails> listMessageDetails = <MessageDetails>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessageDetails.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessageDetails;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data)!);
        }
      }
    }
    return dynamicList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messageDetails in mapList) {
        if (messageDetails != null) {
          idList.add(messageDetails.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<dynamic>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamlist = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (MessageDetails().toMap(messages)!["$key"] == value) {
          if (messages != null) {
            filterParamlist.add(messages.id as String);
          }
        }
      }
    }
    return filterParamlist;
  }
}
