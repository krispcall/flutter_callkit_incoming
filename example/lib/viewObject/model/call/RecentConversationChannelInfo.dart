import "package:mvp/viewObject/common/Object.dart";

class RecentConversationChannelInfo
    extends Object<RecentConversationChannelInfo> {
  String? number;
  String? country;
  String? channelId;

  RecentConversationChannelInfo({
    this.number,
    this.country,
    this.channelId,
  });

  RecentConversationChannelInfo.fromJson(Map<String, dynamic> json) {
    number = json["number"] == null ? null : json["number"] as String;
    country = json["country"] == null ? null : json["country"] as String;
    channelId = json["channelId"] == null ? null : json["channelId"] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["number"] = number;
    data["country"] = country;
    data["channelId"] = channelId;
    return data;
  }

  @override
  RecentConversationChannelInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationChannelInfo(
        number: dynamicData["number"] == null
            ? null
            : dynamicData["number"] as String,
        country: dynamicData["country"] == null
            ? null
            : dynamicData["country"] as String,
        channelId: dynamicData["channelId"] == null
            ? null
            : dynamicData["channelId"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationChannelInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["number"] = object.number;
      data["country"] = object.country;
      data["channelId"] = object.channelId;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationChannelInfo>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationChannelInfo> subCategoryList =
        <RecentConversationChannelInfo>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<RecentConversationChannelInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationChannelInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}
