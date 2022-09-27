import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/holder/request_holder/allContactRequestParamHolder/AllContactRequestParamHolder.dart";

class AllContactRequestHolder extends Holder<AllContactRequestHolder> {
  AllContactRequestHolder({
    required this.param,
    required this.tags,
  });

  final AllContactRequestParamHolder param;
  final String tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["params"] = AllContactRequestParamHolder(
            conversationType: param.conversationType,
            sort: param.sort,
            first: param.first,
            after: param.after,
            afterWith: param.afterWith)
        .toMap();
    map["tags"] = tags;
    return map;
  }

  @override
  AllContactRequestHolder fromMap(dynamic dynamicData) {
    return AllContactRequestHolder(
      param: AllContactRequestParamHolder().fromMap(dynamicData["params"]),
      tags: dynamicData["tags"] as String,
    );
  }
}
