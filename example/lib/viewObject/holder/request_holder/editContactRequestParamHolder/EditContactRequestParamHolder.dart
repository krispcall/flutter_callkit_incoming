import "package:mvp/viewObject/common/Holder.dart";

class EditContactRequestParamHolder
    extends Holder<EditContactRequestParamHolder> {
  EditContactRequestParamHolder({
    required this.company,
    required this.visibility,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.tags,
    required this.profileImageUrl,
  });

  String? company;
  bool? visibility;
  final String? name;
  final String? phoneNumber;
  final String? profileImageUrl;
  String? email;
  String? address;
  List<String>? tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (company != null) {
      map["company"] = company;
    }
    if (visibility != null) {
      map["visibility"] = visibility;
    }
    if (name != null) {
      map["name"] = name;
    }
    if (phoneNumber != null) {
      map["number"] = phoneNumber;
    }
    if (email != null) {
      map["email"] = email;
    }
    if (address != null) {
      map["address"] = address;
    }
    if (tags != null) {
      map["tags"] = tags != null ? tags!.toList() : null;
    }
    if (profileImageUrl != null) {
      map["photoUpload"] = profileImageUrl;
    }
    return map;
  }

  @override
  EditContactRequestParamHolder fromMap(dynamic dynamicData) {
    return EditContactRequestParamHolder(
      company: dynamicData["company"] as String,
      visibility: dynamicData["visibility"] as bool,
      name: dynamicData["name"] as String,
      phoneNumber: dynamicData["number"] as String,
      email: dynamicData["email"] as String,
      address: dynamicData["address"] as String,
      tags: dynamicData["tags"] as List<String>,
      profileImageUrl: dynamicData["photoUpload"] as String,
    );
  }
}
