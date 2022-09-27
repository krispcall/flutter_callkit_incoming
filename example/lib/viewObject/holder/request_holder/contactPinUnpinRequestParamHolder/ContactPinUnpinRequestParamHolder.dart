import "package:mvp/viewObject/common/Holder.dart";

class ContactPinUnPinRequestParamHolder
    extends Holder<ContactPinUnPinRequestParamHolder> {
  final bool? pinned;

  ContactPinUnPinRequestParamHolder({
    this.pinned,
  });

  @override
  ContactPinUnPinRequestParamHolder fromMap(dynamic dynamicData) {
    return ContactPinUnPinRequestParamHolder(
      pinned: dynamicData["pinned"] as bool,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["pinned"] = pinned;
    return map;
  }
}
