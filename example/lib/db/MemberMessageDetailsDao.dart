import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/call/RecentConversationMember.dart";
import "package:sembast/sembast.dart";

class MemberMessageDetailsDao extends Dao<RecentConversationMember> {
  MemberMessageDetailsDao._() {
    init(RecentConversationMember());
  }
  static const String STORE_NAME = "krispcallMvp_MemberConversationDetails";
  final String _primaryKey = "id";

  // Singleton instance
  static final MemberMessageDetailsDao _singleton = MemberMessageDetailsDao._();

  // Singleton accessor
  static MemberMessageDetailsDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(RecentConversationMember object) {
    return object.id!;
  }

  @override
  Filter getFilter(RecentConversationMember object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
