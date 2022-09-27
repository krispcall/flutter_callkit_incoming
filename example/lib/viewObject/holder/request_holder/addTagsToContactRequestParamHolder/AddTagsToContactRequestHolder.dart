import "package:mvp/viewObject/common/Holder.dart";
import "package:mvp/viewObject/holder/request_holder/addTagsToContactRequestParamHolder/AddTagsToContactRequestParamHolder.dart";

class AddTagsToContactRequestHolder
    extends Holder<AddTagsToContactRequestHolder> {
  AddTagsToContactRequestHolder({
    required this.data,
    required this.id,
  });

  AddTagsToContactRequestParamHolder data;
  String id;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data"] = data.toMap();
    map["id"] = id;
    return map;
  }

  @override
  AddTagsToContactRequestHolder fromMap(dynamic dynamicData) {
    return AddTagsToContactRequestHolder(
      data: AddTagsToContactRequestParamHolder().fromMap(dynamicData["data"]),
      id: dynamicData["id"] as String,
    );
  }
}
