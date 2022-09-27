import "package:flutter/services.dart";
import "package:libphonenumber/libphonenumber.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/extension.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";

///Login Validation
String emailPasswordValidation(String email, String password) {
  final emailReg = RegExp(
      r"^((([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  String isValid = "";
  if (email.isEmpty) {
    isValid = Utils.getString("pleaseInputEmail");
  } else if (password.isEmpty) {
    isValid = Utils.getString("pleaseInputPassword");
  } else if (!emailReg.hasMatch(email)) {
    isValid = Utils.getString("pleaseInputValidEmail");
  } else if (!email.trim().limitMax(46)) {
    isValid = Utils.getString("emailLimitError");
  } else if (password.trim().limitMin(5)) {
    isValid = Utils.getString("passwordMinLimitError");
  } else if (!password.trim().limitMax(46)) {
    isValid = Utils.getString("passwordMaxLimitError");
  }
  return isValid;
}

String checkEmailPassword(String email, String password) {
  final emailReg = RegExp(
      r"^((([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  String isValid = "";
  if (email.isEmpty) {
    isValid = Utils.getString("pleaseInputEmail");
  } else if (password.isEmpty) {
    isValid = Utils.getString("pleaseInputPassword");
  } else if (!emailReg.hasMatch(email)) {
    isValid = Utils.getString("pleaseInputValidEmail");
  }
  return isValid;
}

String checkEmail(String email) {
  final emailReg = RegExp(
      r"^((([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z0-9]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  String isValid = "";
  if (email.isEmpty) {
    isValid = Utils.getString("pleaseInputEmail");
  } else if (!emailReg.hasMatch(email)) {
    isValid = Utils.getString("invalidEmail");
  }
  return isValid;
}

String passwordValidation(String password) {
  String isValid = "";
  if (password.isEmpty) {
    isValid = Utils.getString("pleaseInputPassword");
  } else if (password.trim().limitMin(5)) {
    isValid = Utils.getString("passwordMinLimitError");
  } else if (!password.trim().limitMax(46)) {
    isValid = Utils.getString("passwordMaxLimitError");
  }
  return isValid;
}

///Profile validation
String isValidFirstLastName(String firstName, String lastName) {
  String isValid = "";
  if (firstName.isEmpty) {
    isValid = Utils.getString("pleaseInputFirstName");
  } else if (lastName.isEmpty) {
    isValid = Utils.getString("pleaseInputLastName");
  } else if (!firstName.trim().limitMinMax(1, 17)) {
    isValid = Utils.getString("firstNameExceed");
  } else if (!lastName.trim().limitMinMax(1, 43)) {
    isValid = Utils.getString("lastNameExceed");
  } else if (!firstName.checkIsAlphabetic) {
    isValid = Utils.getString("invalidNameFormat");
  } else if (!lastName.checkIsAlphabetic) {
    isValid = Utils.getString("invalidNameFormat");
  }
  return isValid;
}

///Workspace validation
String isValidWorkspaceName(String name) {
  String isValid = "";
  if (name.isEmpty) {
    isValid = Utils.getString("workSpaceEmpty");
  } else if (name.trim().limitMin(1)) {
    isValid = Utils.getString("workSpaceNameMinLimitError");
  } else if (!name.trim().limitMax(44)) {
    isValid = Utils.getString("workSpaceNameMaxLimitError");
  }
  return isValid;
}

///Add Team validation
///Team Name
String isTeamsValidation(String name) {
  String isValid = "";
  if (name.isEmpty) {
    isValid = Utils.getString("teamsEmpty");
  } else if (name.trim().limitMin(1)) {
    isValid = Utils.getString("teamsMinLimitError");
  } else if (!name.trim().limitMax(46)) {
    isValid = Utils.getString("teamsMaxLimitError");
  }
  return isValid;
}

///Team description
String isValidTeamDescriptionValidation(String des) {
  String isValid = "";
  if (!des.trim().limitMax(200)) {
    isValid = Utils.getString("teamsDesExceed");
  }
  return isValid;
}

///Member validation
///Email
String isValidMemberValidation(String email) {
  String isValid = "";
  if (email.isEmpty) {
    isValid = Utils.getString("emptyEmail");
  } else if (!email.trim().checkIsValidEmail) {
    isValid = Utils.getString("invalidEmail");
  } else if (!email.trim().limitMax(46)) {
    isValid = Utils.getString("emailLimitError");
  }
  return isValid;
}

///Tag validation
///Email
String isValidTagsValidation(String tag) {
  String isValid = "";
  if (tag.isEmpty) {
    isValid = Utils.getString("invalidTagName");
  } else if (tag.trim().limitMin(1)) {
    isValid = Utils.getString("tagsMinLimitError");
  } else if (!tag.trim().limitMax(45)) {
    isValid = Utils.getString("tagsMaxLimitError");
  }
  return isValid;
}

String isValidNote(String note) {
  String isValid = "";
  if (note.isEmpty) {
    isValid = Utils.getString("invalidNote");
  } else if (note.trim().limitMin(1)) {
    isValid = Utils.getString("noteMinLimitError");
  } else if (!note.trim().limitMax(200)) {
    isValid = Utils.getString("noteMaxLimitError");
  }
  return isValid;
}

///Contacts
///Email
///
String isContactValidation(
    String name, String phone, String email, String address) {
  String isValid = "";
  if (name.isEmpty) {
    isValid = Utils.getString("fullNameEmpty");
  } else if (!name.trim().limitMinMax(1, 46)) {
    isValid = Utils.getString("contactNameExceed");
  } else if (phone.isEmpty) {
    isValid = Utils.getString("numberEmpty");
  } else if (!phone.trim().limitMinMax(10, 14)) {
    isValid = Utils.getString("numberExceed");
    // } else if (!phone.isValidatePhoneNumbers) {
    //   isValid = Utils.getString("invalidPhoneNumber");
  } else if (email.isNotEmpty) {
    if (!email.checkIsValidEmail) {
      isValid = Utils.getString("pleaseInputValidEmail");
      if (!email.trim().limitMinMax(1, 45)) {
        isValid = Utils.getString("addressExceed");
      }
    }
  } else if (address.isNotEmpty) {
    if (!address.trim().limitMinMax(1, 45)) {
      isValid = Utils.getString("addressExceed");
    }
  }

  return isValid;
}

String isValidPhoneNumber(String phone) {
  String isValid = "";
  if (phone.isEmpty) {
    isValid = Utils.getString("numberEmpty");
  } else if (phone.trim().limitMin(10)) {
    isValid = Utils.getString("invalidPhoneNumber");
  } else if (!phone.trim().limitMax(15)) {
    isValid = Utils.getString("invalidPhoneNumber");
  } else if (phone.contains(" ")) {
    isValid = Utils.getString("invalidPhoneNumber");
  }
  return isValid;
}

String isValidEmail(String email, {bool applyEmptyValidation = true}) {
  String isValid = "";
  if (applyEmptyValidation) {
    if (email.isEmpty) {
      isValid = Utils.getString("emailRequired");
    } else if (!email.trim().checkIsValidEmail) {
      isValid = Utils.getString("invalidEmail");
    } else if (!email.trim().limitMax(46)) {
      isValid = Utils.getString("emailLimitError");
    }
  } else {
    if (email.isNotEmpty) {
      if (!email.trim().checkIsValidEmail) {
        isValid = Utils.getString("invalidEmail");
      } else if (!email.trim().limitMax(46)) {
        isValid = Utils.getString("emailLimitError");
      } else if (!email.trim().checkIsValidEmail) {
        isValid = Utils.getString("invalidEmail");
      }
    }
  }
  return isValid;
}

String isValidAddress(String address) {
  String isValid = "";
  if (address.isEmpty) {
  } else {
    if (address.trim().limitMin(1)) {
      isValid = Utils.getString("addressMinLimitError");
    } else if (!address.trim().limitMax(46)) {
      isValid = Utils.getString("addressMaxLimitError");
    }
  }
  return isValid;
}

String isValidCompany(String company) {
  String isValid = "";
  if (company.isEmpty) {
  } else {
    if (company.trim().limitMin(1)) {
      isValid = Utils.getString("companyMinLimitError");
    } else if (!company.trim().limitMax(46)) {
      isValid = Utils.getString("companyMaxLimitError");
    }
  }

  return isValid;
}

String isValidName(String fullName) {
  String isValid = "";
  if (fullName.isEmpty) {
    isValid = Utils.getString("pleaseInputFirstName");
  } else if (fullName.trim().limitMin(1)) {
    isValid = Utils.getString("fullNameMinLimitError");
  } else if (!fullName.trim().limitMax(46)) {
    isValid = Utils.getString("fullNameMaxLimitError");
  }
  return isValid;
}

String isValidFirstName(String firstname) {
  String isValid = "";
  if (firstname.trim().isEmpty) {
    isValid = Utils.getString("required");
  } else if (firstname.trim().length < 2) {
    isValid = Utils.getString("firstNameShouldContain");
  } else if (!firstname.trim().limitMinMax(2, 18)) {
    isValid = Utils.getString("firstNameLimit");
  } else if (!RegExp(r"^[a-zA-Z]{2,}(?: [a-zA-Z]+)?(?: [a-zA-Z]+)?$")
      .hasMatch(firstname)) {
    isValid = Utils.getString("onlyContainAlphabet");
  }
  return isValid;
}

String isValidLastName(String lastname) {
  String isValid = "";
  if (lastname.trim().isEmpty) {
    isValid = Utils.getString("required");
  } else if (lastname.trim().length < 2) {
    isValid = Utils.getString("lastNameShouldContain");
  } else if (!lastname.trim().limitMinMax(2, 44)) {
    isValid = Utils.getString("lastNameLimit");
  } else if (!RegExp(r"^[a-zA-Z]{2,}(?: [a-zA-Z]+)?(?: [a-zA-Z]+)?$")
      .hasMatch(lastname)) {
    isValid = Utils.getString("onlyContainAlphabet");
  }
  return isValid;
}

String isValidFirstAndLastName(String firstName, String lastName) {
  String isValid = "";
  if (!firstName.trim().limitMinMax(1, 18)) {
    isValid = Utils.getString("firstNameLimit");
  } else if (!lastName.trim().limitMinMax(1, 44)) {
    isValid = Utils.getString("lastNameLimit");
  } else if (!RegExp(r"^[a-zA-Z]{2,}(?: [a-zA-Z]+)?(?: [a-zA-Z]+)?$")
      .hasMatch("$firstName$lastName")) {
    isValid = Utils.getString("onlyContainAlphabet");
  }
  return isValid;
}

Future<String?> checkValidPhoneNumber(
    CountryCode selectedCountryCode, String phone) async {
  String? isValid = "";

  try {
    final bool? valid = await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber: phone, isoCode: selectedCountryCode.code!);
    if (valid != null && valid) {
    } else {
      isValid = Utils.getString("invalidPhoneNumber");
    }
  } on PlatformException catch (e) {
    isValid = e.message;
  }
  return isValid;
}

String validateName(String name) {
  String isValid = "";
  if (name.isEmpty) {
    isValid = Utils.getString("pleaseInputFirstName");
  } else if (name.trim().limitMin(1)) {
    isValid = Utils.getString("fullNameMinLimitError");
  } else if (!name.trim().limitMax(46)) {
    isValid = Utils.getString("fullNameMaxLimitError");
  } else if (!RegExp("^([A-Z][a-z0-9]{1,})").hasMatch(name)) {
    isValid = Utils.getString("invalidName");
  }
  return isValid;
}
