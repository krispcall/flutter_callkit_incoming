import "package:mvp/viewObject/common/Holder.dart";

class ContactsAddParamsHolder extends Holder<ContactsAddParamsHolder> {
  ContactsAddParamsHolder({
    required this.company,
    required this.address,
    required this.visibility,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
  });

  String country;
  String company;
  String address;
  bool visibility;
  final String name;
  final String email;
  final String phoneNumber;
  String? profileImageUrl;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map["country"] = country;
    map["company"] = company;
    map["address"] = address;
    map["visibility"] = visibility;
    map["name"] = name;
    map["email"] = email;
    map["number"] = phoneNumber;
    return map;
  }

  @override
  ContactsAddParamsHolder fromMap(dynamic dynamicData) {
    return ContactsAddParamsHolder(
      country: dynamicData["country"] as String,
      company: dynamicData["company"] as String,
      address: dynamicData["address"] as String,
      visibility: dynamicData["visibility"] as bool,
      name: dynamicData["name"] as String,
      email: dynamicData["email"] as String,
      phoneNumber: dynamicData["number"] as String,
    );
  }
}
