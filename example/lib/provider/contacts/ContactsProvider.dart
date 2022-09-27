import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContact.dart";
import "package:mvp/viewObject/model/addNotes/AddNoteResponse.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponse.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/editContact/EditContactResponse.dart";

class ContactsProvider extends Provider {
  ContactsProvider({
    required this.contactRepository,
    this.valueHolder,
    int limit = 100,
  }) : super(contactRepository!, limit) {
    streamControllerContactEdges =
        StreamController<Resources<AllContactResponse>>.broadcast();
    subscriptionContactEdges = streamControllerContactEdges!.stream
        .listen((Resources<AllContactResponse> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _contactResponse = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerContactDetail =
        StreamController<Resources<Contacts>>.broadcast();
    subscriptionContactDetail = streamControllerContactDetail!.stream
        .listen((Resources<Contacts> resource) {
      _contactDetailResponse = resource;
      isLoading = false;

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerListNotes =
        StreamController<Resources<List<Notes>>>.broadcast();
    subscriptionListNotes = streamControllerListNotes!.stream
        .listen((Resources<List<Notes>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _notes = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    lastContactedDateStream = StreamController<Resources<String>>.broadcast();
    subscriptionLastContactedDate =
        lastContactedDateStream!.stream.listen((Resources<String> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _lastContactedDate = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerContactList =
        StreamController<Resources<List<Contacts>>>.broadcast();
    subscriptionContactList = streamControllerContactList!.stream
        .listen((Resources<List<Contacts>> value) {
      _contactList = value;
      if (!isDispose) {
        notifyListeners();
      }
    });

    validContactStream = StreamController<bool>.broadcast();
    subscriptionIsValidContact =
        validContactStream!.stream.listen((bool value) {
      _isValidContact = value;
      if (!isDispose) {
        notifyListeners();
      }
    });

    dialCodeStream = StreamController<CountryCode>.broadcast();
    subscriptionDialCode = dialCodeStream!.stream.listen((CountryCode value) {
      _dialCode = value;
      if (!isDispose) {
        notifyListeners();
      }
    });

    phoneNumberStream = StreamController<String>.broadcast();
    subscriptionPhoneNumber = phoneNumberStream!.stream.listen((String value) {
      _phoneNumber = value;
    });

    streamControllerCountryFlagUrl = StreamController<String>.broadcast();

    streamControllerContact =
        StreamController<Resources<List<Contacts>>>.broadcast();
    subscriptionContact = streamControllerContact!.stream
        .listen((Resources<List<Contacts>> value) {
      _selectedContact = value;
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerBlockedContactList =
        StreamController<Resources<List<Contacts>>>.broadcast();
    subscriptionBlockedContactList = streamControllerBlockedContactList!.stream
        .listen((Resources<List<Contacts>> value) {
      _blockedContactList = value;
      if (tempData.isEmpty) {
        tempData.addAll(_blockedContactList!.data!);
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerTimeZone = StreamController<String>.broadcast();
    subscriptionTimeZone =
        streamControllerTimeZone!.stream.listen((String value) {
      _timeZone = value;

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ContactRepository? contactRepository;
  ValueHolder? valueHolder;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  StreamController<Resources<AllContactResponse>>? streamControllerContactEdges;
  StreamSubscription<Resources<AllContactResponse>>? subscriptionContactEdges;

  Resources<AllContactResponse>? _contactResponse =
      Resources<AllContactResponse>(Status.NO_ACTION, "", null);

  Resources<AllContactResponse>? get contactResponse => _contactResponse;
  StreamController<Resources<Contacts>>? streamControllerContactDetail;
  StreamSubscription<Resources<Contacts>>? subscriptionContactDetail;
  Resources<Contacts>? _contactDetailResponse =
      Resources<Contacts>(Status.NO_ACTION, "", null);

  Resources<Contacts>? get contactDetailResponse => _contactDetailResponse!;

  /*Notes*/
  StreamController<Resources<List<Notes>>>? streamControllerListNotes;
  StreamSubscription<Resources<List<Notes>>>? subscriptionListNotes;
  Resources<List<Notes>> _notes =
      Resources<List<Notes>>(Status.NO_ACTION, "", null);

  Resources<List<Notes>?>? get notes => _notes;

  /*Lastcontacted*/
  StreamController<Resources<String>>? lastContactedDateStream;
  StreamSubscription<Resources<String>>? subscriptionLastContactedDate;
  Resources<String>? _lastContactedDate =
      Resources<String>(Status.NO_ACTION, "", null);

  Resources<String>? get lastContactedDate => _lastContactedDate;
  bool? _hasContacts = false;

  bool? get hasContacts => _hasContacts;

  /*Contact List*/
  StreamController<Resources<List<Contacts>>>? streamControllerContactList;
  StreamSubscription<Resources<List<Contacts>>>? subscriptionContactList;
  late Resources<List<Contacts>>? _contactList =
      Resources<List<Contacts>>(Status.NO_ACTION, "", []);

  Resources<List<Contacts>>? get contactList => _contactList!;

  /*Contact List*/
  StreamController<Resources<List<Contacts>>>?
      streamControllerBlockedContactList;
  StreamSubscription<Resources<List<Contacts>>>? subscriptionBlockedContactList;
  Resources<List<Contacts>>? _blockedContactList =
      Resources<List<Contacts>>(Status.NO_ACTION, "", null);

  Resources<List<Contacts>>? get blockedContactList => _blockedContactList;

  /*Valid Contact bool stream*/
  StreamController<bool>? validContactStream;
  StreamSubscription<bool>? subscriptionIsValidContact;
  bool _isValidContact = false;

  bool? get isValidContact => _isValidContact;

  /*Valid Contact bool stream*/
  StreamController<CountryCode>? dialCodeStream;
  StreamSubscription<CountryCode>? subscriptionDialCode;
  CountryCode? _dialCode;
  CountryCode? get dialCode => _dialCode;

  /*Valid Contact bool stream*/
  StreamController<String>? phoneNumberStream;
  StreamSubscription<String>? subscriptionPhoneNumber;
  String? _phoneNumber = "";
  String? get phoneNumber => _phoneNumber;

  /*Flag Url*/
  StreamController<String>? streamControllerCountryFlagUrl;
  StreamSubscription<String>? subscriptionCountryFlagUrl;
  final String _selectedFlagUrl = "";
  String get selectedFlagUrl => _selectedFlagUrl;

/*Single contact*/
  StreamController<Resources<List<Contacts>>>? streamControllerContact;
  StreamSubscription<Resources<List<Contacts>>>? subscriptionContact;
  Resources<List<Contacts>> _selectedContact =
      Resources<List<Contacts>>(Status.SUCCESS, "", null);
  Resources<List<Contacts>> get selectedContact => _selectedContact;

  ///Time Zone
  StreamController<String>? streamControllerTimeZone;
  StreamSubscription<String>? subscriptionTimeZone;
  String _timeZone = "";
  String get timeZone => _timeZone;

  @override
  void dispose() {
    streamControllerContactEdges?.close();
    subscriptionContactEdges?.cancel();

    streamControllerContactDetail?.close();
    subscriptionContactDetail?.cancel();

    streamControllerListNotes?.close();
    subscriptionListNotes?.cancel();

    lastContactedDateStream?.close();
    subscriptionLastContactedDate?.cancel();

    streamControllerContactList?.close();
    subscriptionContactList?.cancel();

    streamControllerCountryFlagUrl?.close();

    streamControllerContact?.close();
    subscriptionContact?.cancel();

    dialCodeStream?.close();
    subscriptionDialCode?.cancel();

    streamControllerBlockedContactList?.close();
    subscriptionBlockedContactList?.cancel();

    validContactStream?.close();
    subscriptionIsValidContact?.cancel();

    phoneNumberStream?.close();
    subscriptionPhoneNumber?.cancel();

    streamControllerCountryFlagUrl?.close();
    subscriptionCountryFlagUrl?.cancel();

    streamControllerTimeZone?.close();
    subscriptionTimeZone?.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doEmptyAllContactApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    streamControllerContactEdges!.sink.add(Resources(Status.SUCCESS, "", null));

    return null;
  }

  Future<Resources<AllContactResponse>> doAllContactApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<AllContactResponse> resources =
        await contactRepository!.doAllContactApiCall(
      streamControllerContactEdges!,
      isConnectedToInternet,
      1000000000,
      Status.PROGRESS_LOADING,
    );
    if (resources.data != null &&
        resources.data != null &&
        resources.data!.contactResponse!.contactResponseData!.isNotEmpty) {
      _hasContacts = true;
    }
    return resources;
  }

  Future<dynamic> uploadPhoneContact(
      UploadPhoneContact uploadPhoneContact) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!
        .uploadPhoneContact(isConnectedToInternet, uploadPhoneContact);
  }

  Future<Resources<Contacts>> doContactDetailApiCall(String? contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _contactDetailResponse = await contactRepository!.doContactDetailApiCall(
        streamControllerContactDetail!,
        contactId,
        isConnectedToInternet,
        limit,
        Status.PROGRESS_LOADING);
    return _contactDetailResponse!;
  }

  Future<void> doGetContactDetailApiCall(
      String contactId, Contacts contact) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await contactRepository!.doGetContactDetailApiCall(
      streamControllerContactDetail!,
      contactId,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
      contact,
    );
  }

  Future<Resources<Contacts>> doContactDetailByNumberApiCall(
      String? number) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    streamControllerContactDetail!.sink
        .add(Resources(Status.PROGRESS_LOADING, "", null));

    _contactDetailResponse = await contactRepository!
        .doContactDetailByNumberApiCall(
            number, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if (!streamControllerContactDetail!.isClosed) {
      streamControllerContactDetail!.sink.add(_contactDetailResponse!);
    }
    return _contactDetailResponse!;
  }

  Future<dynamic> doEmptyContactDetailApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    streamControllerContactDetail!.sink
        .add(Resources(Status.SUCCESS, "", null));
    return null;
  }

  Future<dynamic> doAddContactsApiCall(
      AddContactRequestParamHolder jsonMap, File? file) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return contactRepository!.doAddContactsApiCall(
        jsonMap, file, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> getAllContactsFromDB() async {
    final Resources<List<Contacts>> result =
        await contactRepository!.getAllContactsFromDB();

    _contactResponse!.data!.contactResponse!.contactResponseData!.clear();
    _contactResponse!.data!.contactResponse!.contactResponseData!
        .addAll(result.data!);
    streamControllerContactEdges!.sink.add(_contactResponse!);
    return _contactResponse!.data!.contactResponse!.contactResponseData!;
  }

  Future<dynamic> doSearchContactFromDb(String query) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<Contacts>> result = await contactRepository!
        .doSearchContactFromDb(
            query, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if (_contactResponse != null && _contactResponse!.data != null) {
      _contactResponse!.data!.contactResponse!.contactResponseData!.clear();

      _contactResponse!.data!.contactResponse!.contactResponseData!
          .addAll(result.data!);

      if (!streamControllerContactEdges!.isClosed) {
        streamControllerContactEdges!.sink.add(_contactResponse!);
      }
      return _contactResponse!.data!.contactResponse!.contactResponseData;
    }
  }

  Future<Resources<BlockContactResponse>> doBlockContactApiCall(
    BlockContactRequestHolder blockContactRequestHolder,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.doBlockContactApiCall(
      blockContactRequestHolder,
      isConnectedToInternet,
      Status.SUCCESS,
    );
  }

  Future<dynamic> deleteContact(List<String> value) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.deleteContact(
      value,
      isConnectedToInternet,
      Status.SUCCESS,
    );
  }

  Future<dynamic> doUpdateContactProfilePicture(
      Map<String, String> param, String contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return contactRepository!.doUpdateContactProfilePicture(
        param, contactId, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<Resources<EditContactResponse>> editContactApiCall(
      EditContactRequestHolder jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return contactRepository!.editContactApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<Resources<AddNoteResponse>> doAddNoteToContactApiCall(
      AddNoteToContactRequestHolder param) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.doAddNoteToContactApiCall(
        param, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doAddNoteByNumberApiCall(
      AddNoteByNumberRequestHolder param) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.doAddNoteByNumberApiCall(
        param, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doClientDndApiCall(
      UpdateClientDNDRequestParamHolder paramHolder) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return contactRepository!.doRequestForDndConversationByClientNumber(
        paramHolder, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> doGetAllNotesApiCall(
      ContactPinUnpinRequestHolder param) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _notes = await contactRepository!.doGetAllNotesApiCall(
        param, isConnectedToInternet, limit, Status.PROGRESS_LOADING);
    if (!streamControllerListNotes!.isClosed) {
      streamControllerListNotes!.sink.add(_notes);
    }
    return notes;
  }

  Future<dynamic> doGetLastContactedApiCall(
      Map<String, dynamic> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.doGetLastContactedDate(lastContactedDateStream!,
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  bool checkIsEmergencyNumber(String? text) {
    if (text != null) {
      return Config.psSupportedEmergencyNumberMap.containsValue(text);
    } else {
      return false;
    }
  }

  Future<dynamic> doSearchContactNameOrNumber(String query) async {
    await contactRepository!.doSearchContactNameOrNumber(
      query,
      streamControllerContactList!,
    );
  }

  Future<void> validatePhoneNumber(BuildContext context, String text,
      {CountryCode? countryCode}) async {
    contactRepository!.clearContactStream(streamControllerContact!);
    await contactRepository!.validatePhoneNumber(
      context,
      text,
      streamControllerCountryFlagUrl!,
      phoneNumberStream!,
      validContactStream!,
      dialCodeStream!,
      streamControllerContact!,
      selectedCode: countryCode,
    );
  }

  Future<void> validateTimeZone(String text, BuildContext context) async {
    await contactRepository!
        .validateTimeZone(text, streamControllerTimeZone!, context);
  }

  void initalUpdateContactStream(Contacts contact) {
    contactRepository!.sinkContactDetailsStream(
        streamControllerContactDetail!, Resources(Status.SUCCESS, "", contact));
  }

  Future<Resources<List<Contacts>>> doBlockContactListApiCall() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return contactRepository!.doBlockContactListApiCall(
      streamControllerBlockedContactList!,
      isConnectedToInternet,
    );
  }

  List<Contacts> tempData = [];
  List<Contacts> filterData = [];
  Future<dynamic> doSearchBlockContact(String query) async {
    return contactRepository!.doSearchBlockContact(
      query,
      streamControllerBlockedContactList!,
    );
  }
}
