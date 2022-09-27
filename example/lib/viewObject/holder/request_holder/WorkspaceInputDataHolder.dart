import "package:mvp/viewObject/common/Holder.dart";

class WorkSpaceInputDataHolder extends Holder<WorkSpaceInputDataHolder> {
  WorkSpaceInputDataHolder({
    required this.title,
    required this.photo,
  });

  final String title;
  final String photo;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["title"] = title;
    map["photo"] = photo;
    return map;
  }

  @override
  WorkSpaceInputDataHolder fromMap(dynamic dynamicData) {
    return WorkSpaceInputDataHolder(
      title: dynamicData["title"] as String,
      photo: dynamicData["photo"] as String,
    );
  }
}
