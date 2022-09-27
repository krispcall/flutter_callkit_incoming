import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/members/MemberData.dart";
import "package:sembast/sembast.dart";

class MemberDao extends Dao<MemberData> {
  MemberDao._() {
    init(MemberData());
  }
  static const String STORE_NAME = "krispcallMvp_Member";
  final String _primaryKey = "id";

  // Singleton instance
  static final MemberDao _singleton = MemberDao._();

  // Singleton accessor
  static MemberDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(MemberData object) {
    return object.id!;
  }

  @override
  Filter getFilter(MemberData object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
