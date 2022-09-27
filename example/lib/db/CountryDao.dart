import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:sembast/sembast.dart";

class CountryDao extends Dao<CountryCode> {
  CountryDao._() {
    init(CountryCode());
  }
  static const String STORE_NAME = "krispcallMvp_Countries";
  final String _primaryKey = "uid";

  // Singleton instance
  static final CountryDao _singleton = CountryDao._();

  // Singleton accessor
  static CountryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(CountryCode object) {
    return obj!.id!;
  }

  @override
  Filter getFilter(CountryCode object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
