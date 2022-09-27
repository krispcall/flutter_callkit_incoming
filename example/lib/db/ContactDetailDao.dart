import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:sembast/sembast.dart";

class ContactDetailDao extends Dao<Contacts> {
  ContactDetailDao._() {
    init(Contacts());
  }

  static const String STORE_NAME = "krispcallMvp_ContactDetail";
  final String _primaryKey = "id";

  // Singleton instance
  static final ContactDetailDao _singleton = ContactDetailDao._();

  // Singleton accessor
  static ContactDetailDao get instance => _singleton;

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
