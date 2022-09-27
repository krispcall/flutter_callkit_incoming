import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/call/RecentConversation.dart";
import "package:sembast/sembast.dart";

class CallLogDao extends Dao<RecentConversation> {
  CallLogDao._() {
    init(RecentConversation());
  }
  static const String TABLE_NAME = "krispcallMvp_RecentConversation";
  final String _primaryKey = "id";

  // Singleton instance
  static final CallLogDao _singleton = CallLogDao._();

  // Singleton accessor
  static CallLogDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(RecentConversation object) {
    return object.id!;
  }

  @override
  Filter getFilter(RecentConversation object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
