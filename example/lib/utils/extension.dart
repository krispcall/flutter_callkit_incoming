import "package:easy_localization/easy_localization.dart";

extension StringExtension on String {
  ///check is email is valid or not
  bool get checkIsValidEmail {
    final emailReg = RegExp(
        r"^((([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    final bool emailValid = emailReg.hasMatch(this);
    return emailValid;
  }

  bool get checkIsFirstLetterUpperCase {
    final nameReg = RegExp(r"^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$");
    final bool nameValid = nameReg.hasMatch(this);
    return nameValid;
  }

  ///checks at least one Uppercase and Special character
  bool get checkAtLeastUppercaseSpecial {
    final password =
        RegExp("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{6,32}\$");
    return password.hasMatch(this);
  }

  ///checks at least one Number, Uppercase and Special character
  bool get checkAtLeastUppercaseSpecialNumber {
    ///Contains digits, uppercase and special char
    final reg = RegExp(
        "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,32}\$"); //if need digit
    return reg.hasMatch(this);
  }

  ///check password length is valid or not
  bool get checkPasswordLengthIsValid {
    bool isValid = true;
    if (length > 46 || length < 6) {
      isValid = false;
    }
    return isValid;
  }

  ///check valid Phone Numbers
  bool get isValidatePhoneNumbers {
    if (isNotEmpty) {
      final RegExp regExp = RegExp(r"^(?:[+0][1-9])?[0-9]{10,12}$");
      return regExp.hasMatch(this);
    } else {
      return false;
    }
  }

  ///check valid Alphabetic only
  bool get checkIsAlphabetic {
    final reg = RegExp("[A-Za-z]+\$"); //if need digit
    return reg.hasMatch(this);
  }

  /// -------------------------------*/
  String? get firstLetterToUpperCase {
    if (this != null) {
      return this[0].toUpperCase() + substring(1);
    } else {
      return null;
    }
  }

  String? get utcTOLocalTimeHour {
    if (this != null) {
      String date = "";
      try {
        final dateFormat = DateFormat("hh:mm a");
        final String createdDate =
            dateFormat.format(DateTime.parse("${this}Z").toLocal());
        date = createdDate;
      } on Exception catch (_) {}
      return date;
    } else {
      return null;
    }
  }

  bool limitMin(int min) {
    bool isValid = true;
    if (length > min) {
      isValid = false;
    }
    return isValid;
  }

  bool limitMax(int max) {
    bool isValid = true;
    if (length > max) {
      isValid = false;
    }
    return isValid;
  }

  bool limitMinMax(int min, int max) {
    bool isValid = true;
    if (length > max || length < min) {
      isValid = false;
    }
    return isValid;
  }

  String? get utcTOLocalTimeDate {
    if (this != null) {
      String date = "";
      try {
        final dateFormat = DateFormat("yyyy-MM-ddThh:mm a");
        final String createdDate =
            dateFormat.format(DateTime.parse("${this}Z").toLocal());
        date = createdDate;
        return date;
      } on Exception catch (_) {}
      return date;
    } else {
      return null;
    }
  }

  int parseInt() {
    return int.parse(this);
  }

  String get inCaps => "${this[0].toUpperCase()}${substring(1)}";

  String get allInCaps => toUpperCase();

  String get capitalizeFirstofEach =>
      split(" ").map((str) => str.firstLetterToUpperCase).join(" ");
}

extension MapFromList<Element> on List<Element> {
  Map<Key, Element> toMap<Key>(
          MapEntry<Key, Element> Function(Element e) getEntry) =>
      Map.fromEntries(map(getEntry));

  Map<Key, Element> toMapWhereKey<Key>(Key Function(Element e) getKey) =>
      Map.fromEntries(map((e) => MapEntry(getKey(e), e)));
}
