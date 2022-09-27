import "package:mvp/viewObject/common/Holder.dart";

class ContactPinUnpinRequestHolder
    extends Holder<ContactPinUnpinRequestHolder> {
  ContactPinUnpinRequestHolder(
      {required this.channel,
      required this.contact,
      required this.pinned,
      first});

  final String? channel;
  final String? contact;
  final bool? pinned;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["channel"] = channel;
    map["contact"] = contact;
    map["pinned"] = pinned;
    return map;
  }

  @override
  ContactPinUnpinRequestHolder fromMap(dynamic dynamicData) {
    return ContactPinUnpinRequestHolder(
      channel: dynamicData["channel"] as String,
      contact: dynamicData["contact"] as String,
      pinned: dynamicData["pinned"] as bool,
    );
  }
}
