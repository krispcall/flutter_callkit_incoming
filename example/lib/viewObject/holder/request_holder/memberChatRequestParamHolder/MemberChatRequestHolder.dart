import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class MemberChatRequestHolder extends Holder<MemberChatRequestHolder> {
  MemberChatRequestHolder({
    required this.member,
    required this.params,
  });

  final String member;
  final SearchConversationRequestParamHolder params;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["member"] = member;
    map["params"] = SearchConversationRequestParamHolder(
      first: params.first,
      last: params.last,
      after: params.after,
      before: params.before,
      afterWith: params.afterWith,
      beforeWith: params.beforeWith,
      search: params.search,
      q: params.q,
      s: params.s,
      sort: params.sort,
      order: params.order,
    ).toMap();
    return map;
  }

  @override
  MemberChatRequestHolder fromMap(dynamic dynamicData) {
    return MemberChatRequestHolder(
      member: dynamicData["member"] as String,
      params:
          SearchConversationRequestParamHolder().fromMap(dynamicData["params"]),
    );
  }
}
