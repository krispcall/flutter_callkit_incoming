import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponse.dart";
import "package:sembast/sembast.dart";

class ContactDao extends Dao<AllContactResponse> {
  ContactDao._() {
    init(AllContactResponse());
  }

  static const String STORE_NAME = "krispcallMvp_Contacts";
  final String _primaryKey = "id";

  // Singleton instance
  static final ContactDao _singleton = ContactDao._();

  // Singleton accessor
  static ContactDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(AllContactResponse object) {
    return obj!.id!;
  }

  @override
  Filter getFilter(AllContactResponse object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
