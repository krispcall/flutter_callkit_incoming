import "package:mvp/viewObject/common/Holder.dart";

class SearchConversationUsingCursorRequestParamHolder
    extends Holder<SearchConversationUsingCursorRequestParamHolder> {
  final int? last;
  final String? beforeWith;

  SearchConversationUsingCursorRequestParamHolder({this.last, this.beforeWith});

  @override
  SearchConversationUsingCursorRequestParamHolder fromMap(dynamic dynamicData) {
    return SearchConversationUsingCursorRequestParamHolder(
        last: dynamicData["last"] as int,
        beforeWith: dynamicData["beforeWith"] as String);
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (last != null) {
      map["last"] = last;
    }
    if (beforeWith != null) {
      map["beforeWith"] = beforeWith;
    }
    return map;
  }
}
