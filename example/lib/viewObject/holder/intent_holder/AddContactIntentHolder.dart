import "dart:core";

import "package:flutter/cupertino.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";

class AddContactIntentHolder {
  final List<CountryCode>? countryList;
  final CountryCode? defaultCountryCode;
  final String? phoneNumber;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;

  AddContactIntentHolder({
    required this.onIncomingTap,
    required this.onOutgoingTap,
    this.countryList,
    this.defaultCountryCode,
    this.phoneNumber,
  });
}
