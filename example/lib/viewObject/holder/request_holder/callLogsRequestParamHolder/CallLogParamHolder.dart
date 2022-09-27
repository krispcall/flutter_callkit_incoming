import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class CallLogParamHolder extends Holder<CallLogParamHolder> {
  CallLogParamHolder({required this.channel, required this.param, first});

  final String channel;
  final SearchConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["channel"] = channel;
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
  CallLogParamHolder fromMap(dynamic dynamicData) {
    return CallLogParamHolder(
      channel: dynamicData["channel"] as String,
      param: dynamicData["params"] as SearchConversationRequestParamHolder,
    );
  }
}
