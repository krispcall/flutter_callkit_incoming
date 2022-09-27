import "package:mvp/viewObject/common/Holder.dart";
import "package:mvp/viewObject/common/SearchInputRequestParamHolder.dart";

class SearchConversationRequestParamHolder
    extends Holder<SearchConversationRequestParamHolder> {
  final int? first;
  final int? last;
  final String? before;
  final String? after;
  final String? afterWith;
  final String? beforeWith;
  final SearchInputRequestParamHolder? search;
  final String? q;
  final String? s;
  final String? sort;
  final String? order;

  SearchConversationRequestParamHolder({
    this.first,
    this.last,
    this.before,
    this.after,
    this.afterWith,
    this.beforeWith,
    this.search,
    this.q,
    this.s,
    this.sort,
    this.order = "asc",
  });

  @override
  SearchConversationRequestParamHolder fromMap(dynamic dynamicData) {
    return SearchConversationRequestParamHolder(
      first: dynamicData["first"] as int,
      last: dynamicData["last"] as int,
      before: dynamicData["before"] as String,
      after: dynamicData["after"] as String,
      afterWith: dynamicData["afterWith"] as String,
      beforeWith: dynamicData["beforeWith"] as String,
      search: SearchInputRequestParamHolder().fromMap(
        dynamicData["search"] as SearchInputRequestParamHolder,
      ),
      q: dynamicData["q"] as String,
      s: dynamicData["s"] as String,
      sort: dynamicData["sort"] as String,
      order: dynamicData["order"] as String,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    if (first != null) {
      map["first"] = first;
    }

    if (last != null) {
      map["last"] = last;
    }

    if (before != null) {
      map["before"] = before;
    }

    if (after != null) {
      map["after"] = after;
    }

    if (afterWith != null) {
      map["afterWith"] = afterWith;
    }

    if (beforeWith != null) {
      map["beforeWith"] = beforeWith;
    }

    if (search != null) {
      map["search"] = SearchInputRequestParamHolder(
              columns: search!.columns, value: search!.value)
          .toMap();
    }

    if (beforeWith != null) {
      map["beforeWith"] = beforeWith;
    }

    if (q != null) {
      map["q"] = q;
    }

    if (s != null) {
      map["s"] = s;
    }

    if (sort != null) {
      map["sort"] = sort;
    }

    if (order != null) {
      map["order"] = order;
    }

    return map;
  }
}
