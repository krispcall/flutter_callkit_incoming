



import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/call/RecentConversation.dart";
import "package:sembast/sembast.dart";

class MessageDetailsDao extends Dao<RecentConversation> {
  MessageDetailsDao._() {
    init(RecentConversation());
  }
  static const String STORE_NAME = "krispcallMvp_ConversationDetails";
  final String _primaryKey = "id";

  // Singleton instance
  static final MessageDetailsDao _singleton = MessageDetailsDao._();

  // Singleton accessor
  static MessageDetailsDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
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
