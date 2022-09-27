import "dart:async";
import "dart:convert";

import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";

class CountryListProvider extends Provider {
  CountryListProvider({
    required this.countryListRepository,
    int limit = 0,
  }) : super(countryListRepository!, limit) {
    streamControllerCountryCodeList =
        StreamController<Resources<List<CountryCode>>>.broadcast();
    subscriptionCountryCodeList = streamControllerCountryCodeList!.stream
        .listen((Resources<List<CountryCode>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _countryList = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerCountryFlagUrl = StreamController<String>.broadcast();
    subscriptionCountryFlagUrl =
        streamControllerCountryFlagUrl!.stream.listen((String resource) {
      _selectedFlagUrl = resource;
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CountryRepository? countryListRepository;

  StreamController<Resources<List<CountryCode>>>?
      streamControllerCountryCodeList;
  StreamSubscription<Resources<List<CountryCode>>>? subscriptionCountryCodeList;
  Resources<List<CountryCode>>? _countryList =
      Resources<List<CountryCode>>(Status.NO_ACTION, "", <CountryCode>[]);

  Resources<List<CountryCode>>? get countryList => _countryList;

  /*Flag Url*/
  StreamController<String>? streamControllerCountryFlagUrl;
  StreamSubscription<String>? subscriptionCountryFlagUrl;
  String? _selectedFlagUrl = "";

  String? get selectedFlagUrl => _selectedFlagUrl;

  @override
  void dispose() {
    streamControllerCountryCodeList!.close();
    subscriptionCountryCodeList?.cancel();
    streamControllerCountryFlagUrl!.close();
    subscriptionCountryFlagUrl?.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<Resources<List<CountryCode>>> doCountryListApiCall() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _countryList = await countryListRepository!.doCountryListApiCall(
        isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING);
    streamControllerCountryCodeList!.sink.add(_countryList!);
    return _countryList!;
  }

  Future<dynamic> getCountryListFromDb() async {
    isLoading = true;
    _countryList = await countryListRepository!.getCountryListFromDb(
            isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING)
        as Resources<List<CountryCode>>;
    if (!streamControllerCountryCodeList!.isClosed) {
      streamControllerCountryCodeList!.sink.add(_countryList!);
    }
    return _countryList!.data;
  }

  Future<dynamic> replaceDefaultCountryCode(String countryCode) async {
    isLoading = true;
    _countryList = await countryListRepository!.getCountryListFromDb(
            isConnectedToInternet, limit, offset, Status.PROGRESS_LOADING)
        as Resources<List<CountryCode>>;
    if (countryList != null && countryList!.data != null) {
      for (final element in countryList!.data!) {
        if (element.dialCode == countryCode) {
          countryListRepository!
              .replaceDefaultCountryCode(json.encode(element));
          return;
        }
      }
    }
  }

  CountryCode getDefaultCountryCode() {
    isLoading = true;
    final CountryCode countryCode = CountryCode.fromJson(
        json.decode(countryListRepository!.getDefaultCountryCode())
            as Map<String, dynamic>);
    return countryCode;
  }

  void searchCountries(String text) {}

  Future<CountryCode> getCountryById(String countryId) async {
    return countryListRepository!.getCountryCodeById(countryId);
  }

  Future<CountryCode?> getCountryCodeByNumber(String number) async {
    return countryListRepository!.getCountryCodeByNumber(number);
  }

  Future<CountryCode> getCountryByIso(String phoneNumber) async {
    return countryListRepository!.getCountryCodeByIso(phoneNumber);
  }

  void updateCountryFlag(String text,
      {bool isCountrySelected = false, CountryCode? countryCode}) {
    if (isCountrySelected) {
      updateSelectedCountryFlag(countryCode!);
    } else {
      countryListRepository!
          .updateCountryFlag(text, streamControllerCountryFlagUrl!);
    }
  }

  void updateSelectedCountryFlag(CountryCode countryCode) {
    countryListRepository!.sinkFlagUrl(
        PSApp.config!.countryLogoUrl! + countryCode.flagUri!,
        streamControllerCountryFlagUrl!);
  }
}
