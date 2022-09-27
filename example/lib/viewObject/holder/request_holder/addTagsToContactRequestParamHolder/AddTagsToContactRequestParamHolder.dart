import "package:mvp/viewObject/common/Holder.dart";

class AddTagsToContactRequestParamHolder
    extends Holder<AddTagsToContactRequestParamHolder> {
  AddTagsToContactRequestParamHolder({
    this.tags,
  });

  List<String>? tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["tags"] = tags;
    return map;
  }

  @override
  AddTagsToContactRequestParamHolder fromMap(dynamic dynamicData) {
    return AddTagsToContactRequestParamHolder(
      tags:
          (dynamicData["tags"] as List).map((item) => item as String).toList(),
    );
  }
}
