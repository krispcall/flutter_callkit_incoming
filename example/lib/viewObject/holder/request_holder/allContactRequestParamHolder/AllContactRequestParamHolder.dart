import "package:mvp/viewObject/common/Holder.dart";

class AllContactRequestParamHolder
    extends Holder<AllContactRequestParamHolder> {
  final String? sort;
  final String? conversationType;
  final int? first;
  final String? before;
  final String? after;
  final String? afterWith;
  final String? order;

  AllContactRequestParamHolder({
    this.before,
    this.after,
    this.conversationType,
    this.sort,
    this.first,
    this.afterWith,
    this.order,
  });

  @override
  AllContactRequestParamHolder fromMap(dynamic dynamicData) {
    return AllContactRequestParamHolder(
      conversationType: dynamicData["q"] as String,
      first: dynamicData["first"] as int,
      after: dynamicData["after"] as String,
      before: dynamicData["before"] as String,
      afterWith: dynamicData["afterWith"] as String,
      order: dynamicData["order"] as String,
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
    if (order != null) {
      map["order"] = order;
    }
    return map;
  }
}
