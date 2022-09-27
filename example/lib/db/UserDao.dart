import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:sembast/sembast.dart";

class UserDao extends Dao<UserProfileData> {
  UserDao._() {
    init(UserProfileData());
  }

  static const String STORE_NAME = "krispcallMvp_User";
  final String _primaryKey = "email";

  // Singleton instance
  static final UserDao _singleton = UserDao._();

  // Singleton accessor
  static UserDao get instance => _singleton;

  @override
  String getPrimaryKey(UserProfileData object) {
    return object.email!;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(UserProfileData object) {
    return Filter.equals(_primaryKey, object.email);
  }
}
