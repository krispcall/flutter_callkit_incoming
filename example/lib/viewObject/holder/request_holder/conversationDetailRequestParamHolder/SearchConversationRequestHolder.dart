import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class SearchConversationRequestHolder
    extends Holder<SearchConversationRequestHolder> {
  SearchConversationRequestHolder({
    required this.channel,
    required this.contact,
    required this.param,
  });

  final String channel;
  final String contact;
  final SearchConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["channel"] = channel;
    map["contact"] = contact;
    map["params"] = SearchConversationRequestParamHolder(
      first: param.first,
      last: param.last,
      after: param.after,
      before: param.before,
      afterWith: param.afterWith,
      beforeWith: param.beforeWith,
      search: param.search,
      q: param.q,
      s: param.s,
      sort: param.sort,
      order: param.order,
    ).toMap();
    return map;
  }

  @override
  SearchConversationRequestHolder fromMap(dynamic dynamicData) {
    return SearchConversationRequestHolder(
      channel: dynamicData["channel"] as String,
      contact: dynamicData["contact"] as String,
      param:
          SearchConversationRequestParamHolder().fromMap(dynamicData["params"]),
    );
  }
}
