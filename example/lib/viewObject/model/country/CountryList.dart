import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/country/CountryListData.dart";

class CountryList extends Object<CountryList> {
  CountryList({
    this.countryListData,
  });

  CountryListData? countryListData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CountryList? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CountryList(
          countryListData:
              CountryListData().fromMap(dynamicData["allCountries"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CountryList? object) {
    if (object != null) {
      final Map<String, dynamic> data = {};
      data["allCountries"] = CountryListData().toMap(object.countryListData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CountryList>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CountryList> data = <CountryList>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<CountryList>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CountryList data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
