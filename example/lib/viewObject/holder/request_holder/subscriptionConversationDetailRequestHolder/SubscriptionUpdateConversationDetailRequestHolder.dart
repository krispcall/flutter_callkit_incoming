import "package:mvp/viewObject/common/Holder.dart" show Holder;

class SubscriptionUpdateConversationDetailRequestHolder
    extends Holder<SubscriptionUpdateConversationDetailRequestHolder> {
  SubscriptionUpdateConversationDetailRequestHolder({
    required this.channelId,
  });

  final String? channelId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["channel"] = channelId;
    return map;
  }

  @override
  SubscriptionUpdateConversationDetailRequestHolder fromMap(
      dynamic dynamicData) {
    return SubscriptionUpdateConversationDetailRequestHolder(
      channelId: dynamicData["channel"] as String,
    );
  }
}
