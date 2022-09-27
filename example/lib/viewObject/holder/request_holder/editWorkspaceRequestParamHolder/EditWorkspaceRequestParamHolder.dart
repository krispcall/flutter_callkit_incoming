import "package:mvp/viewObject/common/Holder.dart";

class EditWorkspaceRequestParamHolder
    extends Holder<EditWorkspaceRequestParamHolder> {
  EditWorkspaceRequestParamHolder({
    required this.title,
  });

  String title;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["title"] = title;
    return map;
  }

  @override
  EditWorkspaceRequestParamHolder fromMap(dynamic dynamicData) {
    return EditWorkspaceRequestParamHolder(
      title: dynamicData["title"] as String,
    );
  }
}
