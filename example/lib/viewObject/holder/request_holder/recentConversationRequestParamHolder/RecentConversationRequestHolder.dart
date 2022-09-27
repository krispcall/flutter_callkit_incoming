import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class RecentConversationRequestHolder extends Holder<RecentConversationRequestHolder> {
  RecentConversationRequestHolder({required this.channel, this.param});

  final String? channel;
  final SearchConversationRequestParamHolder? param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (channel!=null && channel!.isNotEmpty) {
      map["channel"] = channel;
    }
    if (param != null) {
      map["params"] = SearchConversationRequestParamHolder(
        first: param!.first,
        last: param!.last,
        after: param!.after,
        before: param!.before,
        afterWith: param!.afterWith,
        beforeWith: param!.beforeWith,
        search: param!.search,
        q: param!.q,
        s: param!.s,
        sort: param!.sort,
        order: param!.order,
      ).toMap();
    }
    return map;
  }

  @override
  RecentConversationRequestHolder fromMap(dynamic dynamicData) {
    return RecentConversationRequestHolder(
      channel: dynamicData["channel"] as String,
      param:
          SearchConversationRequestParamHolder().fromMap(dynamicData["params"]),
    );
  }
}
