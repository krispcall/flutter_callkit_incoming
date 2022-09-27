import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/agent/AgentInfo.dart";
import "package:mvp/viewObject/model/call/RecentConversationChannelInfo.dart";
import "package:mvp/viewObject/model/call/RecentConversationClientInfo.dart";
import "package:mvp/viewObject/model/call/RecentConversationContent.dart";
import "package:mvp/viewObject/model/call/RecentConversationPersonalizedInfo.dart";
import "package:quiver/core.dart";

enum ConversationType { Call, Message, VoiceMail }

class RecentConversationNodes extends Object<RecentConversationNodes> {
  RecentConversationNodes({
    this.id,
    this.conversationType,
    this.conversationStatus,
    this.direction,
    this.createdAt,
    this.clientNumber,
    this.contactPinned,
    this.clientCountry,
    this.clientUnseenMsgCount,
    this.status,
    this.content,
    this.clientInfo,
    this.reject,
    this.personalizedInfo,
    this.channelInfo,
    this.agentInfo,
  });

  String? id;
  String? conversationType;
  String? conversationStatus;
  String? direction;
  String? createdAt;
  String? clientNumber;
  bool? contactPinned;
  String? clientCountry;
  int? clientUnseenMsgCount;
  String? status;
  RecentConversationContent? content;
  RecentConversationClientInfo? clientInfo;
  RecentConversationChannelInfo? channelInfo;
  bool? reject;
  RecentConversationPersonalizedInfo? personalizedInfo;
  AgentInfo? agentInfo;

  @override
  bool operator ==(dynamic other) =>
      other is RecentConversationNodes && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  RecentConversationNodes? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationNodes(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        createdAt: dynamicData["createdAt"] == null
            ? null
            : dynamicData["createdAt"] as String,
        clientNumber: dynamicData["clientNumber"] == null
            ? null
            : dynamicData["clientNumber"] as String,
        clientCountry: dynamicData["clientCountry"] == null
            ? null
            : dynamicData["clientCountry"] as String,
        contactPinned: dynamicData["contactPinned"] == null
            ? null
            : dynamicData["contactPinned"] as bool,
        clientUnseenMsgCount: dynamicData["clientUnseenMsgCount"] == null
            ? null
            : dynamicData["clientUnseenMsgCount"] as int,
        reject: dynamicData["reject"] == null
            ? null
            : dynamicData["reject"] as bool,
        conversationType: dynamicData["conversationType"] == null
            ? null
            : dynamicData["conversationType"] as String,
        conversationStatus: dynamicData["conversationStatus"] == null
            ? null
            : dynamicData["conversationStatus"] as String,
        status: dynamicData["status"] == null
            ? null
            : dynamicData["status"] as String,
        content: dynamicData["content"] != null
            ? RecentConversationContent().fromMap(dynamicData["content"])
            : null,
        clientInfo: dynamicData["clientInfo"] != null
            ? RecentConversationClientInfo().fromMap(dynamicData["clientInfo"])
            : null,
        personalizedInfo: dynamicData["personalizedInfo"] != null
            ? RecentConversationPersonalizedInfo()
                .fromMap(dynamicData["personalizedInfo"])
            : null,
        channelInfo: dynamicData["channelInfo"] != null
            ? RecentConversationChannelInfo()
                .fromMap(dynamicData["channelInfo"])
            : null,
        direction: dynamicData["direction"] == null
            ? null
            : dynamicData["direction"] as String,
        agentInfo: dynamicData["agentInfo"] != null
            ? AgentInfo().fromMap(dynamicData["agentInfo"])
            : null,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationNodes? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["createdAt"] = object.createdAt;
      data["clientNumber"] = object.clientNumber;
      data["clientCountry"] = object.clientCountry;
      data["contactPinned"] = object.contactPinned;
      data["clientUnseenMsgCount"] = object.clientUnseenMsgCount;
      data["reject"] = object.reject;
      data["status"] = object.status;
      data["conversationStatus"] = object.conversationStatus;
      data["conversationType"] = object.conversationType;
      data["content"] = object.content != null
          ? RecentConversationContent().toMap(object.content!)
          : null;
      data["clientInfo"] = object.clientInfo != null
          ? RecentConversationClientInfo().toMap(object.clientInfo!)
          : null;
      data["personalizedInfo"] = object.personalizedInfo != null
          ? RecentConversationPersonalizedInfo().toMap(object.personalizedInfo!)
          : null;
      data["channelInfo"] = object.channelInfo != null
          ? RecentConversationChannelInfo().toMap(object.channelInfo!)
          : null;
      data["direction"] = object.direction;
      data["agentInfo"] = AgentInfo().toMap(object.agentInfo);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationNodes>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversationNodes> basketList =
        <RecentConversationNodes>[];

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
      List<RecentConversationNodes>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationNodes data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
