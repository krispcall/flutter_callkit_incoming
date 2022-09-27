import "package:azlistview/azlistview.dart";

class UploadPhoneContact {
  List<PhoneContact>? contacts;

  UploadPhoneContact({this.contacts});

  UploadPhoneContact.fromJson(Map<String, dynamic> json) {
    if (json["contacts"] != null) {
      contacts = [];
      json["contacts"].forEach((v) {
        contacts!.add(PhoneContact.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contacts != null) {
      data["contacts"] = contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhoneContact extends ISuspensionBean {
  String? number;
  String? fullName;
  String? tagIndex;
  String? namePinyin;
  bool? isSelected;

  PhoneContact({this.number, this.fullName, this.isSelected});

  PhoneContact.fromJson(Map<String, dynamic> json) {
    number = json["number"] == null ? null : json["number"] as String;
    fullName = json["fullName"] == null ? null : json["fullName"] as String;
    isSelected = json["isSelected"] == null ? null : json["isSelected"] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["number"] = number;
    data["fullName"] = fullName;
    // data["isSelected"] = isSelected;
    return data;
  }

  @override
  String toString() {
    return "{ $fullName, $number ,$isSelected}";
  }

  @override
  String getSuspensionTag() => tagIndex!;
}
