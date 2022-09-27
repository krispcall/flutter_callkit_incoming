import "package:mvp/viewObject/common/Holder.dart";

class ProfileUpdateParameterHolder
    extends Holder<ProfileUpdateParameterHolder> {
  ProfileUpdateParameterHolder({
    required this.userId,
    required this.userEmail,
    required this.userPhone,
    required this.userName,
    required this.userAboutMe,
    required this.userLat,
    required this.userLng,
  });

  final String userId;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userAboutMe;
  final String userLat;
  final String userLng;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map["user_id"] = userId;
    map["user_name"] = userName;
    map["user_email"] = userEmail;
    map["user_phone"] = userPhone;
    map["user_about_me"] = userAboutMe;
    map["user_lat"] = userLat;
    map["user_lng"] = userLng;

    return map;
  }

  @override
  ProfileUpdateParameterHolder fromMap(dynamic dynamicData) {
    return ProfileUpdateParameterHolder(
      userId: dynamicData["user_id"] as String,
      userName: dynamicData["user_name"] as String,
      userEmail: dynamicData["user_email"] as String,
      userPhone: dynamicData["user_phone"] as String,
      userAboutMe: dynamicData["user_about_me"] as String,
      userLat: dynamicData["user_lat"] as String,
      userLng: dynamicData["user_lng"] as String,
    );
  }
}

/*Filed Update Param Holder*/

class UserNameUpdateParamHolder extends Holder<UserNameUpdateParamHolder> {
  final String firstName;
  final String lastName;

  UserNameUpdateParamHolder(
      {required this.firstName, required this.lastName});

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    return map;
  }

  @override
  UserNameUpdateParamHolder fromMap(dynamic dynamicData) {
    return UserNameUpdateParamHolder(
        firstName: dynamicData["firstName"] as String,
        lastName: dynamicData["lastName"] as String);
  }
}

class UserUpdateEmailParamHolder extends Holder<UserUpdateEmailParamHolder> {
  final String email;

  UserUpdateEmailParamHolder({required this.email});

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["email"] = email;
    return map;
  }

  @override
  UserUpdateEmailParamHolder fromMap(dynamic dynamicData) {
    return UserUpdateEmailParamHolder(email: dynamicData["email"] as String);
  }
}

class UserUpdateProfileParamHolder
    extends Holder<UserUpdateProfileParamHolder> {
  final String image;

  UserUpdateProfileParamHolder({required this.image});

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["photo_upload"] = image;
    return map;
  }

  @override
  UserUpdateProfileParamHolder fromMap(dynamic dynamicData) {
    return UserUpdateProfileParamHolder(
        image: dynamicData["photo_upload"] as String);
  }
}
