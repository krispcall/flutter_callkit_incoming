import "package:mvp/viewObject/common/Holder.dart";

class EditTagRequestParamHolder extends Holder<EditTagRequestParamHolder> {
  EditTagRequestParamHolder({
    required this.data,
    required this.id,
  });

  Map<String, dynamic> data;
  String id;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data"] = data;
    map["id"] = id;
    return map;
  }

  @override
  EditTagRequestParamHolder fromMap(dynamic dynamicData) {
    return EditTagRequestParamHolder(
      data: dynamicData["data"] as Map<String, dynamic>,
      id: dynamicData["id"] as String,
    );
  }
}
