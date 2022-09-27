import "package:mvp/viewObject/common/Holder.dart";

class AddContactRequestParamHolder
    extends Holder<AddContactRequestParamHolder> {
  AddContactRequestParamHolder({
    required this.company,
    required this.visibility,
    required this.name,
    required this.phoneNumber,
    required this.country,
    required this.email,
    required this.address,
    this.tags,
  });

  String country;
  String company;
  bool visibility;
  final String name;
  final String phoneNumber;
  String? profileImageUrl;
  String email;
  String address;
  List<String>? tags;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (country.isNotEmpty) {
      map["country"] = country;
    }
    if (company.isNotEmpty) {
      map["company"] = company;
    }
    map["visibility"] = visibility;
    if (name.isNotEmpty) {
      map["name"] = name;
    }
    if (phoneNumber.isNotEmpty) {
      map["number"] = phoneNumber;
    }
    if (email.isNotEmpty) {
      map["email"] = email;
    }
    if (address.isNotEmpty) {
      map["address"] = address;
    }
    if (tags != null) {
      map["tags"] = tags != null ? tags!.toList() : null;
    }
    return map;
  }

  @override
  AddContactRequestParamHolder fromMap(dynamic dynamicData) {
    return AddContactRequestParamHolder(
      country: dynamicData["country"] as String,
      company: dynamicData["company"] as String,
      visibility: dynamicData["visibility"] as bool,
      name: dynamicData["name"] as String,
      phoneNumber: dynamicData["number"] as String,
      email: dynamicData["email"] as String,
      address: dynamicData["address"] as String,
      tags: dynamicData["tags"] as List<String>,
    );
  }
}
