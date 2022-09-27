import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversationReceiverMember.dart";
import "package:mvp/viewObject/model/call/RecentConversationSenderMember.dart";
import "package:quiver/core.dart";

class RecentConversationMemberNodes
    extends Object<RecentConversationMemberNodes> {
  RecentConversationMemberNodes({
    this.id,
    this.message,
    this.createdOn,
    this.modifiedOn,
    this.sender,
    this.receiver,
    this.status,
    this.type,
  });

  String? id;
  String? message;
  String? createdOn;
  String? modifiedOn;
  RecentConversationSenderMember? sender;
  RecentConversationReceiverMember? receiver;
  String? status;
  String? type;

  @override
  bool operator ==(dynamic other) =>
      other is RecentConversationMemberNodes && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  RecentConversationMemberNodes? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationMemberNodes(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        message: dynamicData["message"] == null
            ? null
            : dynamicData["message"] as String,
        createdOn: dynamicData["createdOn"] == null
            ? null
            : dynamicData["createdOn"] as String,
        modifiedOn: dynamicData["modifiedOn"] == null
            ? null
            : dynamicData["modifiedOn"] as String,
        receiver:
            RecentConversationReceiverMember().fromMap(dynamicData["receiver"]),
        sender: RecentConversationSenderMember().fromMap(dynamicData["sender"]),
        status: dynamicData["status"] == null
            ? null
            : dynamicData["status"] as String,
        type:
            dynamicData["type"] == null ? null : dynamicData["type"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationMemberNodes? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["message"] = object.message;
      data["createdOn"] = object.createdOn;
      data["modifiedOn"] = object.modifiedOn;
      data["receiver"] = object.receiver != null
          ? RecentConversationReceiverMember().toMap(object.receiver)
          : null;
      data["sender"] = object.sender != null
          ? RecentConversationSenderMember().toMap(object.sender)
          : null;
      data["status"] = object.status;
      data["type"] = object.type;
      return data;
    } else {
      return null;
    }
  }

  Map toJson() {
    final Map data = {};
    data["id"] = id;
    data["message"] = message;
    data["createdOn"] = createdOn;
    data["modifiedOn"] = modifiedOn;
    data["receiver"] = receiver != null
        ? RecentConversationReceiverMember().toMap(receiver)
        : null;
    data["sender"] =
        sender != null ? RecentConversationSenderMember().toMap(sender) : null;
    data["status"] = status;
    data["type"] = type;
    return data;
  }

  @override
  List<RecentConversationMemberNodes>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationMemberNodes> basketList =
        <RecentConversationMemberNodes>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<RecentConversationMemberNodes>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationMemberNodes data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
