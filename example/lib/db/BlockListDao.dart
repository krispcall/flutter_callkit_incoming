import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:sembast/sembast.dart";

class BlockListDao extends Dao<Contacts> {
  BlockListDao._() {
    init(Contacts());
  }

  static const String STORE_NAME = "krispcallMvp_BlockList";
  final String _primaryKey = "id";

  // Singleton instance
  static final BlockListDao _singleton = BlockListDao._();

  // Singleton accessor
  static BlockListDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Contacts object) {
    return obj!.id!;
  }

  @override
  Filter getFilter(Contacts object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
