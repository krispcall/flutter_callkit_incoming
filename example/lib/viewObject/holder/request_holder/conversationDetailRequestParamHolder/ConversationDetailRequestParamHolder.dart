import "package:mvp/viewObject/common/Holder.dart";

class ConversationDetailRequestParamHolder
    extends Holder<ConversationDetailRequestParamHolder> {
  final String ?sort;
  final String? conversationType;
  final int? first;
  final int? last;
  final String? before;
  final String? after;
  final String? afterWith;
  final String? beforeWith;

  ConversationDetailRequestParamHolder({
    this.before,
    this.after,
    this.conversationType,
    this.sort,
    this.first,
    this.last,
    this.afterWith,
    this.beforeWith,
  });

  @override
  ConversationDetailRequestParamHolder fromMap(dynamic dynamicData) {
    return ConversationDetailRequestParamHolder(
      conversationType: dynamicData["q"] as String,
      first: dynamicData["first"] as int,
      after: dynamicData["after"] as String,
      before: dynamicData["before"] as String,
      last: dynamicData["last"] as int,
      afterWith: dynamicData["afterWith"] as String,
      beforeWith: dynamicData["beforeWith"] as String,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    if (conversationType != null) {
      map["q"] = conversationType;
    }

    if (first != null) {
      map["first"] = first;
    }
    if (after != null) {
      map["after"] = after;
    }
    if (before != null) {
      map["before"] = before;
    }
    if (afterWith != null) {
      map["afterWith"] = afterWith;
    }
    if (last != null) {
      map["last"] = last;
    }
    if (beforeWith != null) {
      map["beforeWith"] = beforeWith;
    }
    return map;
  }
}
