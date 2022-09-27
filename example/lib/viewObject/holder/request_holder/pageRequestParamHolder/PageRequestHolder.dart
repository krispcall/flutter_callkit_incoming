import "package:mvp/viewObject/common/Holder.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";

class PageRequestHolder extends Holder<PageRequestHolder> {
  PageRequestHolder({required this.param});

  final SearchConversationRequestParamHolder param;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["pageParams"] = SearchConversationRequestParamHolder(
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
  PageRequestHolder fromMap(dynamic dynamicData) {
    return PageRequestHolder(
      param: SearchConversationRequestParamHolder().fromMap(
          dynamicData["pageParams"] as SearchConversationRequestParamHolder),
    );
  }
}
