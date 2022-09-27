import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:sembast/sembast.dart";

class NumberSettingsDao extends Dao<NumberSettings> {
  NumberSettingsDao._() {
    init(NumberSettings());
  }
  static const String TABLE_NAME = "krispcallMvp_NumberSettings";
  final String _primaryKey = "id";

  // Singleton instance
  static final NumberSettingsDao _singleton = NumberSettingsDao._();

  // Singleton accessor
  static NumberSettingsDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(NumberSettings object) {
    return object.id!;
  }

  @override
  Filter getFilter(NumberSettings object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
