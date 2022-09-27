import "dart:async";
import "dart:convert";

import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/CountryDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/country/CountryList.dart";
import "package:sembast/sembast.dart";

class CountryRepository extends Repository {
  ApiService? apiService;
  CountryDao? countryDao;
  String primaryKey = "uid";

  CountryRepository({required this.apiService, required this.countryDao});

  Future<Resources<List<CountryCode>>> doCountryListApiCall(
      bool isConnectedToInternet, int limit, int offset, Status status) async {
    if (isConnectedToInternet) {
      final Resources<CountryList> resource =
          await apiService!.getAllCountries(limit, offset);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.countryListData!.error == null) {
          await countryDao!.deleteAll();
          await countryDao!.insertAll(
              primaryKey, resource.data!.countryListData!.countryCode);
          return Resources(
              Status.SUCCESS, "", resource.data!.countryListData!.countryCode);
        } else {
          return countryDao!.getAll();
        }
      } else {
        return countryDao!.getAll();
      }
    } else {
      return countryDao!.getAll();
    }
  }

  Future<dynamic> getCountryListFromDb(
      bool isConnectedToInternet, int limit, int offset, Status status) async {
    return countryDao!.getAll();
  }

  Future<CountryCode> getCountryCodeById(String countryId) async {
    final Resources<CountryCode>? resources = await countryDao!
        .getOne(finder: Finder(filter: Filter.matches("uid", countryId)));
    return Future.value(resources!.data);
  }

  Future<CountryCode?> getCountryCodeByNumber(String number) async {
    final Resources<List<CountryCode>> resources = await countryDao!.getAll();
    for (int i = 0; i < resources.data!.length; i++) {
      if (number.contains(resources.data![i].dialCode!)) {
        return resources.data![i];
      }
    }
    return null;
  }

  Future<CountryCode> getCountryCodeByIso(String clientNumber) async {
    bool isNumberFormatOk = true;
    try {} catch (e) {
      isNumberFormatOk = false;
    }
    if (isNumberFormatOk) {
      final PhoneNumber phoneNumber =
          await PhoneNumber.getRegionInfoFromPhoneNumber(clientNumber);
      final Resources<CountryCode>? resources = await countryDao!.getOne(
          finder: Finder(
              filter: Filter.matchesRegExp("alphaTwoCode",
                  RegExp(phoneNumber.isoCode!, caseSensitive: false))));
      return Future.value(resources!.data);
    } else {
      final Resources<CountryCode> resources =
          Resources(Status.SUCCESS, "", CountryCode());
      return Future.value(resources.data);
    }
  }

  Future<CountryCode> getCountryCodeAlphaCode(String alphaCode) async {
    final Resources<CountryCode>? resources = await countryDao!.getOne(
        finder: Finder(
            filter: Filter.matchesRegExp("alphaTwoCode", RegExp(alphaCode, caseSensitive: false))));
    return Future.value(resources!.data);
  }

  CountryCode? countryCode;

  Future<void> updateCountryFlag(String text, StreamController<String> streamControllerCountryFlagUrl) async {
    try {
      final Resources<List<CountryCode>> resources = await countryDao!.getAll();
      for (final element in resources.data!) {
        if (text.contains(element.dialCode!)) {
          countryCode = element;
        }
      }


      if (countryCode != null) {
        if (countryCode!.dialCode == "+1" && text.length > 2) {
          final String dumper = text.split("+1")[1];
          String dump2 = "";
          if (dumper.length > 2) {
            dump2 = dumper.substring(0, 3);
          } else {
            dump2 = dumper;
          }
          for (int i = 0; i < Utils.canadaList.length; i++) {
            if (dump2.contains(Utils.canadaList[i])) {
              countryCode = await getCountryCodeAlphaCode("CA");
              break;
            } else {
              countryCode = await getCountryCodeAlphaCode("US");
            }
          }
        }

        if (countryCode!.dialCode == "+61") {
          if (text.length > 4) {
            final String dump = text.split("+61")[1];
            if (dump.contains(Utils.australiaList[0])) {
              countryCode = await getCountryCodeAlphaCode("CC");
            } else if (dump.contains(Utils.australiaList[1])) {
              countryCode = await getCountryCodeAlphaCode("CX");
            } else {
              countryCode = await getCountryCodeAlphaCode("AU");
            }
          } else {
            countryCode = await getCountryCodeAlphaCode("AU");
          }
        }

        if (countryCode!.dialCode == "+672") {
          final String dump = text.split("+672")[1];
          for (int i = 0; i < Utils.norkforkIlandList.length; i++) {
            if (dump.contains(Utils.norkforkIlandList[i])) {
              countryCode = await getCountryCodeAlphaCode("NF");
              break;
            }
          }
        }

        if (countryCode!.dialCode == "+672") {
          final String dump = text.split("+672")[1];
          for (int i = 0; i < Utils.anterticaCodeList.length; i++) {
            if (dump.contains(Utils.anterticaCodeList[i])) {
              countryCode = await getCountryCodeAlphaCode("AQ");
              break;
            }
          }
        }

        sinkFlagUrl(PSApp.config!.countryLogoUrl! + countryCode!.flagUri!,
            streamControllerCountryFlagUrl);
      } else {
        final CountryCode countryCode = CountryCode.fromJson(
            json.decode(getDefaultCountryCode()) as Map<String, dynamic>);
        sinkFlagUrl(PSApp.config!.countryLogoUrl! + countryCode.flagUri!,
            streamControllerCountryFlagUrl);
      }
    } catch (e) {
      sinkFlagUrl("${PSApp.config!.countryLogoUrl}$countryCode!.flagUri", streamControllerCountryFlagUrl);
    }
  }

  void sinkFlagUrl(String flgUrl, StreamController<String> streamControllerCountryFlagUrl) {

    if (!streamControllerCountryFlagUrl.isClosed) {
      streamControllerCountryFlagUrl.sink.add(flgUrl);
    }

  }
}
