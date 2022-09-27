import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class TeamsMemberListRequestParamHolder
    extends Holder<TeamsMemberListRequestParamHolder> {
  TeamsMemberListRequestParamHolder(
      {required this.teamId, required this.param, first});

  final String teamId;
  final SearchConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = teamId;
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
  TeamsMemberListRequestParamHolder fromMap(dynamic dynamicData) {
    return TeamsMemberListRequestParamHolder(
      teamId: dynamicData["id"] as String,
      param: dynamicData["params"] as SearchConversationRequestParamHolder,
    );
  }
}
