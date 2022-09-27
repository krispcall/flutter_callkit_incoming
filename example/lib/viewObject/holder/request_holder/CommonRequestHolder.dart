import "package:mvp/viewObject/common/Holder.dart";

class CommonRequestHolder extends Holder<CommonRequestHolder> {
  dynamic data;

  CommonRequestHolder({this.data});

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data"] = data;
    return map;
  }

  @override
  CommonRequestHolder fromMap(dynamic dynamicData) {
    return CommonRequestHolder(
      data: dynamicData,
    );
  }
}
