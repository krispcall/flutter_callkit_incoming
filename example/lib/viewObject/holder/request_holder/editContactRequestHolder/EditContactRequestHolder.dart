import "package:mvp/viewObject/common/Holder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestParamHolder/EditContactRequestParamHolder.dart";

class EditContactRequestHolder extends Holder<EditContactRequestHolder> {
  EditContactRequestHolder({
    required this.data,
    required this.id,
  });

  EditContactRequestParamHolder data;
  String id;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data"] = data.toMap();
    map["id"] = id;
    return map;
  }

  @override
  EditContactRequestHolder fromMap(dynamic dynamicData) {
    return EditContactRequestHolder(
      data: dynamicData["data"] as EditContactRequestParamHolder,
      id: dynamicData["id"] as String,
    );
  }
}
