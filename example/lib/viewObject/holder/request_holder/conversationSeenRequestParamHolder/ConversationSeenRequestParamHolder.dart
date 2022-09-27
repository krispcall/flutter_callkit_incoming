import "package:mvp/viewObject/common/Holder.dart";

class ConversationSeenRequestParamHolder
    extends Holder<ConversationSeenRequestParamHolder> {
  final String? contact;
  final String? channel;

  ConversationSeenRequestParamHolder({this.contact, this.channel});

  @override
  ConversationSeenRequestParamHolder fromMap(dynamic dynamicData) {
    return ConversationSeenRequestParamHolder(
      contact: dynamicData["contact"] as String,
      channel: dynamicData["channel"] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (contact != null) {
      map["contact"] = contact;
    }
    if (channel != null) {
      map["channel"] = channel;
    }
    return map;
  }
}
