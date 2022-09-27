import "package:mvp/viewObject/model/country/CountryCode.dart";

class DefaultCountryCode {
  String? workspaceId;
  String? workspaceName;
  CountryCode? countryCode;

  DefaultCountryCode({this.workspaceId, this.workspaceName, this.countryCode});

  DefaultCountryCode.fromJson(Map<String, dynamic> json) {
    workspaceId =
        json["workspaceId"] == null ? null : json["workspaceId"] as String;
    workspaceName =
        json["workspaceName"] == null ? null : json["workspaceName"] as String;
    countryCode = json["countryCode"] != null
        ? CountryCode.fromJson(json["countryCode"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["workspaceId"] = workspaceId;
    data["workspaceName"] = workspaceName;
    if (countryCode != null) {
      data["countryCode"] = countryCode!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return "$workspaceId $workspaceName";
  }
}

// class CountryCode {
//   String id;
//   String name;
//   String flagUri;
//   String code;
//   String dialCode;
//   String length;
//
//   CountryCode(
//       {this.id,
//         this.name,
//         this.flagUri,
//         this.code,
//         this.dialCode,
//         this.length});
//
//   CountryCode.fromJson(Map<String, dynamic> json) {
//     id = json["id"];
//     name = json["name"];
//     flagUri = json["flagUri"];
//     code = json["code"];
//     dialCode = json["dialCode"];
//     length = json["length"];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data["id"] = this.id;
//     data["name"] = this.name;
//     data["flagUri"] = this.flagUri;
//     data["code"] = this.code;
//     data["dialCode"] = this.dialCode;
//     data["length"] = this.length;
//     return data;
//   }
// }
