import "dart:async";
import "dart:convert";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/BlockListDao.dart";
import "package:mvp/db/ContactDao.dart";
import "package:mvp/db/ContactDetailDao.dart";
import "package:mvp/db/CountryDao.dart";
import "package:mvp/db/NotesDao.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNoteByNumberRequestParamHolder/AddNoteByNumberRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addNotesToContactRequestParamHolder/AddNoteToContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:mvp/viewObject/holder/request_holder/contactDetailRequestParamHolder/ContactDetailRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart";
import "package:mvp/viewObject/model/addContact/AddContactResponse.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContact.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContactResponse.dart";
import "package:mvp/viewObject/model/addNoteByNumber/AddNoteByNumberResponse.dart";
import "package:mvp/viewObject/model/addNotes/AddNoteResponse.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponse.dart";
import "package:mvp/viewObject/model/allContact/AllContactResponseData.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/allNotes/AllNotesResponse.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:mvp/viewObject/model/blockContact/BlockContactListResponse.dart";
import "package:mvp/viewObject/model/clientDndResponse/ClientDndResponse.dart";
import "package:mvp/viewObject/model/contactDetail/ContactDetailResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/editContact/EditContactResponse.dart";
import "package:mvp/viewObject/model/last_contacted/LastContactedData.dart";
import "package:mvp/viewObject/model/last_contacted/LastContactedResponse.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";
import "package:provider/provider.dart";
import "package:sembast/sembast.dart";
import "package:timeago/timeago.dart" as timeago;
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/standalone.dart" as tzz;

class ContactRepository extends Repository {
  ContactRepository({
    required this.apiService,
    required this.contactDao,
    required this.contactDetailDao,
    required this.notesDao,
    required this.countryDao,
    required this.blockListDao,
  });

  String primaryKey = "";
  ApiService? apiService;
  ContactDao? contactDao;
  ContactDetailDao? contactDetailDao;
  PageInfo? pageInfo;
  NotesDao? notesDao;
  CountryDao? countryDao;
  BlockListDao? blockListDao;

  Future<Resources<AllContactResponse>> doAllContactApiCall(
      StreamController<Resources<AllContactResponse>>
          streamControllerContactEdges,
      bool isConnectedToInternet,
      int limit,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllContactResponse> resource =
          await apiService!.doAllContactApiCall();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.contactResponse!.error == null) {
          final List<Map> contactList = resource
              .data!.contactResponse!.contactResponseData!
              .map((e) => {
                    "number": e.number,
                    "name": e.name,
                    "imageUrl": e.profilePicture
                  })
              .toList();
          Utils.getSharedPreference().then((psSharePref) async {
            psSharePref.setString(
                Const.VALUE_HOLDER_CONTACT_LIST, jsonEncode(contactList));
          });
          await contactDao!.deleteWithFinder(
            Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(getDefaultWorkspace(), caseSensitive: false),
              ),
            ),
          );

          await contactDao!.insert(
            getDefaultWorkspace(),
            AllContactResponse(
              contactResponse: resource.data!.contactResponse,
              id: getDefaultWorkspace(),
            ),
          );

          final Resources<AllContactResponse>? dump = await contactDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(getDefaultWorkspace(), caseSensitive: false),
              ),
            ),
          );

          Utils.cPrint(
              "Contact Length Get ${dump?.data?.contactResponse?.contactResponseData?.length}");

          if (!streamControllerContactEdges.isClosed) {
            streamControllerContactEdges
                .add(Resources(Status.SUCCESS, "", dump?.data));
          }
          return Resources(Status.SUCCESS, "", dump?.data);
        } else {
          final Resources<AllContactResponse>? dump = await contactDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(getDefaultWorkspace(), caseSensitive: false),
              ),
            ),
          );
          streamControllerContactEdges
              .add(Resources(Status.SUCCESS, "", dump?.data));
          return Resources(Status.SUCCESS, "", dump?.data);
        }
      } else {
        final Resources<AllContactResponse>? dump = await contactDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(getDefaultWorkspace(), caseSensitive: false),
            ),
          ),
        );
        streamControllerContactEdges
            .add(Resources(Status.SUCCESS, "", dump?.data));
        return Resources(Status.SUCCESS, "", dump?.data);
      }
    } else {
      final Resources<AllContactResponse>? dump = await contactDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(getDefaultWorkspace(), caseSensitive: false),
          ),
        ),
      );
      streamControllerContactEdges
          .add(Resources(Status.SUCCESS, "", dump?.data));
      return Resources(Status.SUCCESS, "", dump?.data);
    }
  }

  Future<dynamic> uploadPhoneContact(
      bool isConnectedToInternet, UploadPhoneContact uploadPhoneContact) async {
    if (isConnectedToInternet) {
      final Resources<UploadPhoneContactResponse> resource =
          await apiService!.doUploadContactsApiCall(uploadPhoneContact);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.uploadBulkContacts!.error == null) {
          return Resources(
              Status.SUCCESS, "Contact uploaded successfully", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.uploadBulkContacts!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<Resources<Contacts>> doContactDetailApiCall(
    StreamController<Resources<Contacts>> streamControllerContactDetail,
    String? uid,
    bool isConnectedToInternet,
    int limit,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    if (uid!.isNotEmpty) {
      if (isConnectedToInternet) {
        final Resources<ContactDetailResponse> resource =
            await apiService!.doContactDetailApiCall(
          ContactDetailRequestParamHolder(
            uid: uid,
          ),
        );

        if (resource.status == Status.SUCCESS) {
          if (resource.data!.contactDetailResponseData!.error == null) {
            if (resource.data!.contactDetailResponseData!.contacts != null) {
              final String dump = resource
                  .data!.contactDetailResponseData!.contacts!.number!
                  .replaceAll("+", "");
              await contactDetailDao!.deleteWithFinder(
                Finder(
                  filter: Filter.matchesRegExp(
                      "number", RegExp(dump, caseSensitive: false)),
                ),
              );
              await contactDetailDao!.insert(
                  dump, resource.data!.contactDetailResponseData!.contacts!);
              sinkContactDetailsStream(
                  streamControllerContactDetail,
                  Resources(Status.SUCCESS, "",
                      resource.data!.contactDetailResponseData!.contacts));
              return Resources(Status.SUCCESS, "",
                  resource.data!.contactDetailResponseData!.contacts);
            } else {
              return Resources(Status.SUCCESS, "", null);
            }
          } else {
            return Resources(Status.ERROR,
                resource.data!.contactDetailResponseData!.error!.message, null);
          }
        } else {
          return Resources(Status.ERROR, "", null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("noInternet"), null);
      }
    } else {
      return Resources(Status.ERROR, "", null);
    }
  }

  Future<dynamic> doGetContactDetailApiCall(
    StreamController<Resources<Contacts>> streamControllerContactDetail,
    String uid,
    bool isConnectedToInternet,
    int limit,
    Status status,
    Contacts contact, {
    bool isLoadFromServer = true,
  }) async {
    sinkContactDetailsStream(
        streamControllerContactDetail, Resources(Status.SUCCESS, "", contact));
    if (uid.isNotEmpty) {
      if (isConnectedToInternet) {
        final Resources<ContactDetailResponse> resource =
            await apiService!.doContactDetailApiCall(
          ContactDetailRequestParamHolder(
            uid: uid,
          ),
        );
        if (resource.status == Status.SUCCESS) {
          if (resource.data!.contactDetailResponseData!.error == null) {
            if (resource.data!.contactDetailResponseData!.contacts != null) {
              final String dump = resource
                  .data!.contactDetailResponseData!.contacts!.number!
                  .replaceAll("+", "");
              await contactDetailDao!.deleteWithFinder(
                Finder(
                  filter: Filter.matchesRegExp(
                      "number", RegExp(dump, caseSensitive: false)),
                ),
              );
              await contactDetailDao!.insert(
                  dump, resource.data!.contactDetailResponseData!.contacts!);
              sinkContactDetailsStream(
                  streamControllerContactDetail,
                  Resources(Status.SUCCESS, "",
                      resource.data!.contactDetailResponseData!.contacts));
            }
          }
        }
      }
    }
  }

  Future<Resources<Contacts>> doContactDetailByNumberApiCall(
      String? number, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<ClientDetailResponse> resource =
          await apiService!.doContactDetailByNumberApiCall(
        ContactDetailByNumberRequestParamHolder(
          number: number,
        ),
      );

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.contactDetailResponseData!.error == null) {
          if (resource.data!.contactDetailResponseData!.contacts != null) {
            final String? dump = number?.replaceAll("+", "");
            await contactDetailDao!.deleteWithFinder(
              Finder(
                filter: Filter.matchesRegExp(
                    "number", RegExp(dump!, caseSensitive: false)),
              ),
            );
            await contactDetailDao!.insert(
                dump, resource.data!.contactDetailResponseData!.contacts!);
            return Resources(Status.SUCCESS, "",
                resource.data!.contactDetailResponseData!.contacts);
          } else {
            return Resources(Status.SUCCESS, "", null);
          }
        } else {
          return Resources(Status.ERROR,
              resource.data!.contactDetailResponseData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("notInternet"), null);
    }
  }

  Future<dynamic> doUpdateContactProfilePicture(Map<String, String> param,
      String contactId, bool isConnectedToInternet, Status isLoading) async {
    if (isConnectedToInternet) {
      final Resources<EditContactResponse> resource =
          await apiService!.doUpdateContactProfilePicture(param, contactId);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.editContactResponseData!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.editContactResponseData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<EditContactResponse>> editContactApiCall(
      EditContactRequestHolder jsonMap,
      bool isConnectedToInternet,
      Status isLoading) async {
    if (isConnectedToInternet) {
      final Resources<EditContactResponse> resource =
          await apiService!.editContactApiCall(jsonMap);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.editContactResponseData!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.editContactResponseData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    } else {
      return Resources(Status.ERROR, "", null);
    }
  }

  Future<Resources<List<Contacts>>> getAllContactsFromDB() async {
    final Resources<AllContactResponse>? dump = await contactDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(getDefaultWorkspace(), caseSensitive: false),
        ),
      ),
    );
    return Resources(
        Status.SUCCESS, "", dump!.data!.contactResponse!.contactResponseData);
  }

  Future<Resources<List<Contacts>>> doSearchContactFromDb(
      String query, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<AllContactResponse>? dump = await contactDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(getDefaultWorkspace(), caseSensitive: false),
        ),
      ),
    );

    final Resources<List<Contacts>> result = Resources(Status.SUCCESS, "", []);
    if (query.contains("+")) {
      if (dump?.data!.contactResponse!.contactResponseData!.indexWhere(
              (element) => element.number!
                  .toLowerCase()
                  .contains(query.toLowerCase())) ==
          -1) {
      } else {
        for (final element
            in dump!.data!.contactResponse!.contactResponseData!) {
          if (element.number!.toLowerCase().contains(query.toLowerCase())) {
            result.data!.add(element);
          }
        }
      }
    } else {
      if (dump!.data!.contactResponse!.contactResponseData!.indexWhere(
                  (element) => element.name!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ==
              -1 &&
          dump.data!.contactResponse!.contactResponseData!.indexWhere(
                  (element) => element.number!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ==
              -1) {
      } else {
        for (final element
            in dump.data!.contactResponse!.contactResponseData!) {
          if (element.name!.toLowerCase().contains(query.toLowerCase()) ||
              element.number!.toLowerCase().contains(query.toLowerCase())) {
            result.data!.add(element);
          }
        }
      }
    }

    return result;
  }

  Future<Resources<AddContactResponse>> doAddContactsApiCall(
      AddContactRequestParamHolder jsonMap,
      File? file,
      bool isConnectedToInternet,
      Status success,
      {bool isLoadFromServer = true}) async {
    final Resources<AddContactResponse> resource =
        await apiService!.postAddContacts(jsonMap.toMap(), file);

    if (resource.status == Status.SUCCESS) {
      if (resource.data!.addContactResponseData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(Status.ERROR,
            resource.data!.addContactResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<BlockContactResponse>> doBlockContactApiCall(
    BlockContactRequestHolder blockContactRequestHolder,
    bool isConnectedToInternet,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    final Resources<BlockContactResponse> resource =
        await apiService!.doBlockContactApiCall(
      blockContactRequestHolder,
    );
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.blockContact == null) {
        if (!blockContactRequestHolder.data.isBlock!) {
          final Resources<List<Contacts>> result = await blockListDao!.getAll();

          if (result.data != null && result.data!.isNotEmpty) {
            if (result.data!.indexWhere((element) =>
                    element.number == blockContactRequestHolder.number) ==
                -1) {
            } else {
              result.data!.removeAt(
                result.data!.indexWhere((element) =>
                    element.number == blockContactRequestHolder.number),
              );
              await blockListDao!.deleteAll();
              await blockListDao!.insertAll(primaryKey, result.data);
            }
          }
        }
        return resource;
      } else {
        return Resources(
            Status.ERROR, resource.data!.blockContact!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<DeleteContactResponse>> deleteContact(
      List<String> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<DeleteContactResponse> resource =
        await apiService!.deleteContact(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.data!.error == null) {
        return resource;
      } else {
        return Resources(
            Status.ERROR, resource.data!.data!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<AddNoteResponse>> doAddNoteToContactApiCall(
      AddNoteToContactRequestHolder param,
      bool isConnectedToInternet,
      Status status) async {
    final Resources<AddNoteResponse> resource =
        await apiService!.doAddNoteToContactApiCall(param);

    if (resource.status == Status.SUCCESS) {
      if (resource.data!.addNoteResponseData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(Status.ERROR,
            resource.data!.addNoteResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doAddNoteByNumberApiCall(AddNoteByNumberRequestHolder param,
      bool isConnectedToInternet, Status status) async {
    final Resources<AddNoteByNumberResponse> resource =
        await apiService!.doAddNoteByNumberApiCall(param);

    if (resource.status == Status.SUCCESS) {
      if (resource.data!.addNoteByNumberResponseData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(Status.ERROR,
            resource.data!.addNoteByNumberResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doRequestForDndConversationByClientNumber(
      UpdateClientDNDRequestParamHolder paramHolder,
      bool isConnectedToInternet,
      Status status) async {
    final Resources<ClientDndResponse> resource = await apiService!
        .doRequestToMuteConversationByClientNumber(paramHolder);

    if (resource.status == Status.SUCCESS) {
      if (resource.data!.clientDndResponseData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(Status.ERROR,
            resource.data!.clientDndResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<List<Notes>>> doGetAllNotesApiCall(
      ContactPinUnpinRequestHolder param,
      bool isConnectedToInternet,
      int limit,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<AllNotesResponse> resource =
          await apiService!.doGetAllNotesApiCall(param);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.clientNotes!.error == null) {
          await notesDao!.deleteAll();
          await notesDao!
              .insertAll(primaryKey, resource.data?.clientNotes?.listNotes);
          return Resources(
              Status.SUCCESS, "", resource.data?.clientNotes?.listNotes);
        } else {
          return Resources(
              Status.ERROR, resource.data?.clientNotes?.error?.message, []);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), []);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), []);
    }
  }

  Future<dynamic> doGetLastContactedDate(
      StreamController<Resources<String>> lastContactedDateStream,
      Map<String, dynamic> jsonMap,
      bool isConnectedToInternet,
      Status progressLoading) async {
    if (isConnectedToInternet) {
      final Resources<LastContactedResponse> resource =
          await apiService!.doGetLastContactedDate(jsonMap);
      Utils.cPrint("this is created date json data $jsonMap");
      Utils.cPrint(
          "this is created date ${LastContactedData().toMap(resource.data?.data)}");
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null &&
            resource.data!.data!.data != null) {
          if (!lastContactedDateStream.isClosed) {
            lastContactedDateStream.sink.add(
              Resources(
                Status.SUCCESS,
                "",
                timeago.format(
                    DateTime.now().subtract(DateTime.now().difference(
                        DateTime.parse(
                            resource.data?.data?.data?["createdAt"] == null
                                ? ""
                                : resource.data?.data?.data?["createdAt"]
                                    as String))),
                    locale: "en"),
              ),
            );
          }
        } else {
          return Resources(
              Status.ERROR, resource.data!.data!.error?.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  void sinkContactDetailsStream(
      StreamController<Resources<Contacts>> streamControllerContactDetail,
      Resources<Contacts> resources) {
    if (!streamControllerContactDetail.isClosed) {
      streamControllerContactDetail.sink.add(resources);
    }
  }

  Future<dynamic> doSearchContactNameOrNumber(
    String query,
    StreamController<Resources<List<Contacts>>> streamControllerContactEdges,
  ) async {
    Resources<AllContactResponse>? result = await contactDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(getDefaultWorkspace(), caseSensitive: false),
        ),
      ),
    );

    if (query.isNotEmpty) {
      if (query.contains("+")) {
        ///TODO
        if (result!.data!.contactResponse!.contactResponseData!.indexWhere(
                (element) => element.number!
                    .toLowerCase()
                    .contains(query.toLowerCase())) ==
            -1) {
          final CountryCode countryCode = Utils.checkCountryCodeExist(
              query, (await countryDao!.getAll()).data!)!;

          if (await Utils.checkValidPhoneNumber(countryCode, query)) {
            if (!Config.psSupportedEmergencyNumberMap.containsKey(query)) {
              final List<Contacts> listHolder = [];
              listHolder.add(
                Contacts(
                  check: false,
                  workspaceId: getDefaultWorkspace(),
                  country: "",
                  blocked: false,
                  name: query,
                  number: query,
                  // dndEnabled: false,
                  // dndMissed: false,
                  dndInfo: DndInfo(),
                  notes: [],
                  tags: [],
                  visibility: false,
                  email: "",
                ),
              );
              result = Resources(
                Status.SUCCESS,
                "",
                AllContactResponse(
                  id: getDefaultWorkspace(),
                  contactResponse: AllContactResponseData(
                    status: 200,
                    contactResponseData: listHolder,
                  ),
                ),
              );
            } else {
              result = Resources(
                Status.SUCCESS,
                "",
                AllContactResponse(
                  id: getDefaultWorkspace(),
                  contactResponse: AllContactResponseData(
                    status: 200,
                    contactResponseData: [],
                  ),
                ),
              );
            }
          } else {
            if (query.contains("+31")) {
              final RegExp regExp = RegExp(r"^[+31][0-9]{11,15}$");
              if (!regExp.hasMatch(query)) {
                result = Resources(
                  Status.SUCCESS,
                  "",
                  AllContactResponse(
                    id: getDefaultWorkspace(),
                    contactResponse: AllContactResponseData(
                      status: 200,
                      contactResponseData: [],
                    ),
                  ),
                );
              } else {
                result = Resources(
                  Status.SUCCESS,
                  "",
                  AllContactResponse(
                    id: getDefaultWorkspace(),
                    contactResponse: AllContactResponseData(
                      status: 200,
                      contactResponseData: [
                        Contacts(
                          check: false,
                          workspaceId: getDefaultWorkspace(),
                          country: "",
                          blocked: false,
                          name: query,
                          number: query,
                          // dndEnabled: false,
                          // dndMissed: false,
                          dndInfo: DndInfo(),
                          notes: [],
                          tags: [],
                          visibility: false,
                          email: "",
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else if (query.contains("+372")) {
              final RegExp regExp = RegExp(r"^[+372][0-9]{10,12}$");
              if (!regExp.hasMatch(query)) {
                result = Resources(
                  Status.SUCCESS,
                  "",
                  AllContactResponse(
                    id: getDefaultWorkspace(),
                    contactResponse: AllContactResponseData(
                      status: 200,
                      contactResponseData: [],
                    ),
                  ),
                );
              } else {
                result = Resources(
                  Status.SUCCESS,
                  "",
                  AllContactResponse(
                    id: getDefaultWorkspace(),
                    contactResponse: AllContactResponseData(
                      status: 200,
                      contactResponseData: [
                        Contacts(
                          check: false,
                          workspaceId: getDefaultWorkspace(),
                          country: "",
                          blocked: false,
                          name: query,
                          number: query,
                          // dndEnabled: false,
                          // dndMissed: false,
                          dndInfo: DndInfo(),
                          notes: [],
                          tags: [],
                          visibility: false,
                          email: "",
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              result = Resources(
                Status.SUCCESS,
                "",
                AllContactResponse(
                  id: getDefaultWorkspace(),
                  contactResponse: AllContactResponseData(
                    status: 200,
                    contactResponseData: [],
                  ),
                ),
              );
            }
          }
          sinkContactEdgesStream(
              streamControllerContactEdges,
              Resources(Status.SUCCESS, "",
                  result.data!.contactResponse!.contactResponseData));
          sinkContactEdgesStream(
              streamControllerContactEdges,
              Resources(Status.SUCCESS, "",
                  result.data!.contactResponse!.contactResponseData));
        } else {
          final Resources<List<Contacts>> toReturn =
              Resources(Status.SUCCESS, "", []);
          for (final element
              in result.data!.contactResponse!.contactResponseData!) {
            if (element.number!.toLowerCase().contains(query.toLowerCase())) {
              toReturn.data!.add(element);
            }
          }
          sinkContactEdgesStream(streamControllerContactEdges,
              Resources<List<Contacts>>(Status.SUCCESS, "", toReturn.data));
        }
      } else {
        final Resources<List<Contacts>> toReturn =
            Resources(Status.SUCCESS, "", []);
        if (result!.data!.contactResponse!.contactResponseData!.indexWhere(
                (element) => element.name!
                    .toLowerCase()
                    .contains(query.toLowerCase())) ==
            -1) {
        } else {
          for (final element
              in result.data!.contactResponse!.contactResponseData!) {
            if (element.name!.toLowerCase().contains(query.toLowerCase())) {
              toReturn.data!.add(element);
            }
          }
        }
        sinkContactEdgesStream(streamControllerContactEdges,
            Resources<List<Contacts>>(Status.SUCCESS, "", toReturn.data));
      }
    } else {
      sinkContactEdgesStream(
          streamControllerContactEdges,
          Resources<List<Contacts>>(Status.SUCCESS, "",
              result!.data!.contactResponse!.contactResponseData));
    }
  }

  void sinkContactEdgesStream(
      StreamController<Resources<List<Contacts>>> streamControllerContactEdges,
      Resources<List<Contacts>> result) {
    if (!streamControllerContactEdges.isClosed) {
      streamControllerContactEdges.sink.add(result);
    }
  }

  Future<void> validatePhoneNumber(
      BuildContext context,
      String text,
      StreamController<String> streamControllerCountryFlagUrl,
      StreamController<String> phoneNumberStream,
      StreamController<bool> validContactStream,
      StreamController<CountryCode> dialCodeStream,
      StreamController<Resources<List<Contacts>>> streamControllerContact,
      {CountryCode? selectedCode}) async {
    CountryCode? countryCode;

    try {
      final Resources<List<CountryCode>> resources = await countryDao!.getAll();
      if (selectedCode != null) {
        countryCode = resources.data!
            .where((e) =>
                e.dialCode == selectedCode.dialCode &&
                e.code == selectedCode.code)
            .first;
      } else {
        for (final element in resources.data!) {
          if (text.contains(element.dialCode!)) {
            countryCode = element;
          }
        }
      }

      if (countryCode! != null) {
        if (countryCode.dialCode == "+1" && text.length > 2) {
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

        if (countryCode.dialCode == "+672") {
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
        sinkDialCodeStream(countryCode, dialCodeStream);
        if (await Utils.checkValidPhoneNumber(countryCode, text)) {
          sinkIsValidNumberStream(true, validContactStream);
        } else {
          sinkIsValidNumberStream(false, validContactStream);
        }
        try {
          final Resources<AllContactResponse>? resources =
              await contactDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(getDefaultWorkspace(), caseSensitive: false),
              ),
            ),
          );
          final List<Contacts> dump = [];
          for (final element
              in resources!.data!.contactResponse!.contactResponseData!) {
            if (element.number!.contains(text)) {
              dump.add(element);
            }
          }
          if (resources.data != null) {
            sinkNumberIsFromContact(
              streamControllerContact,
              Resources(
                Status.SUCCESS,
                "",
                dump,
              ),
            );
          }
          /*Emergency number validation*/
        } catch (e) {
          Utils.cPrint(e.toString());
        }
        if (text.length > 1) {
          sinkPhoneNumberStream(
              text.substring(countryCode.dialCode!.length, text.length),
              phoneNumberStream);
        }
      } else {
        sinkFlagUrl("", streamControllerCountryFlagUrl);

        if (text.length > 2) {
          sinkDialCodeStream(
              CountryCode(
                id: "",
                dialCode: text.substring(0, 3),
                flagUri: "",
                code: "",
              ),
              dialCodeStream);
          sinkPhoneNumberStream(
              text.substring(3, text.length), phoneNumberStream);
        } else {
          sinkDialCodeStream(
              CountryCode(
                id: "",
                dialCode: text,
                flagUri: "",
                code: "",
              ),
              dialCodeStream);
          sinkPhoneNumberStream("", phoneNumberStream);
        }
      }
      Provider.of<DashboardProvider>(context, listen: false)
          .selectedCountryCode = countryCode;
    } catch (e) {
      // Utils.showToastMessage(e.toString()); //null check operator used a null value
      Utils.cPrint("contact_repo_error==> ${e.toString()}");
    }
  }

  Future<void> validateTimeZone(
    String text,
    StreamController<String> streamControllerTimeZone,
    BuildContext context,
  ) async {
    final data = Provider.of<DashboardProvider>(context, listen: false);
    final StateCodeResponse dump = StateCodeResponse().fromMap(data.areaCode)!;
    for (int i = 0; i < dump.stateCodes!.length; i++) {
      if (text.contains(dump.stateCodes![i].dialCode!)) {
        tz.initializeTimeZones();
        final timezone = tzz.getLocation(dump.stateCodes![i].stateCenter!);
        final now = tzz.TZDateTime.now(timezone);
        final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
        final formatDay = DateFormat.EEEE();
        streamControllerTimeZone.sink.add(
            "${DateFormat('hh:mm a').format(dt).toUpperCase()}  ${formatDay.format(dt)}, in ${dump.stateCodes![i].country}");
        break;
      } else {
        streamControllerTimeZone.sink.add("");
      }
    }
  }

  Future<CountryCode> getCountryCodeAlphaCode(String alphaCode) async {
    final Resources<CountryCode>? resources = await countryDao!.getOne(
        finder: Finder(
            filter: Filter.matchesRegExp(
                "alphaTwoCode", RegExp(alphaCode, caseSensitive: false))));
    return Future.value(resources!.data);
  }

  void sinkFlagUrl(
      String flgUrl, StreamController<String> streamControllerCountryFlagUrl) {
    if (!streamControllerCountryFlagUrl.isClosed) {
      streamControllerCountryFlagUrl.sink.add(flgUrl);
    }
  }

  void sinkDialCodeStream(
      CountryCode dialCode, StreamController<CountryCode> dialCodeStream) {
    if (!dialCodeStream.isClosed) {
      dialCodeStream.sink.add(dialCode);
    }
  }

  void sinkIsValidNumberStream(
      bool bool, StreamController<bool> validContactStream) {
    if (!validContactStream.isClosed) {
      validContactStream.sink.add(bool);
    }
  }

  void sinkPhoneNumberStream(
      String phoneNumber, StreamController<String> phoneNumberStream) {
    if (!phoneNumberStream.isClosed) {
      phoneNumberStream.sink.add((phoneNumber.isNotEmpty) ? phoneNumber : "");
    }
  }

  void sinkNumberIsFromContact(
      StreamController<Resources<List<Contacts>>> streamControllerContact,
      Resources<List<Contacts>> resources) {
    if (!streamControllerContact.isClosed) {
      streamControllerContact.sink.add(resources);
    }
  }

  void clearContactStream(
      StreamController<Resources<List<Contacts>>> streamControllerContact) {
    sinkNumberIsFromContact(
        streamControllerContact, Resources(Status.SUCCESS, "", null));
  }

  void sinkEmergencyNumberStream(
      bool value, StreamController<bool> streamIsEmergencyNumber) {
    if (!streamIsEmergencyNumber.isClosed) {
      streamIsEmergencyNumber.sink.add(value);
    }
  }

  void sinkContactListStream(
      StreamController<Resources<AllContactResponse>>
          streamControllerContactEdges,
      Resources<AllContactResponse> resources) {
    if (!streamControllerContactEdges.isClosed) {
      streamControllerContactEdges.sink.add(resources);
    }
  }

  Future<Resources<List<Contacts>>> doBlockContactListApiCall(
      StreamController<Resources<List<Contacts>>> streamControllerContactList,
      bool isConnectedToInternet) async {
    if (isConnectedToInternet) {
      final Resources<BlockContactListResponse> resources =
          await apiService!.doBlockContactListApiCall();

      if (resources.status == Status.SUCCESS) {
        if (resources.data!.blockContacts!.error == null) {
          final List<Contacts> blockContacts =
              Contacts().fromMapList(resources.data!.blockContacts!.data);
          final List<Contacts> list = [];
          for (final Contacts value in blockContacts) {
            value.workspaceId = getDefaultWorkspace();
            list.add(value);
          }

          await blockListDao!.deleteAll();
          await blockListDao!.insertAll(primaryKey, list);

          if (!streamControllerContactList.isClosed) {
            streamControllerContactList.sink
                .add(Resources(Status.SUCCESS, "", list));
          }

          return Resources(Status.SUCCESS, "", list);
        } else {
          final Resources<List<Contacts>> dump = await blockListDao!.getAll();
          if (!streamControllerContactList.isClosed) {
            streamControllerContactList.sink.add(
              Resources(
                Status.SUCCESS,
                "",
                dump.data,
              ),
            );
          }
          return dump;
        }
      } else {
        final Resources<List<Contacts>> dump = await blockListDao!.getAll();
        if (!streamControllerContactList.isClosed) {
          streamControllerContactList.sink.add(
            Resources(
              Status.SUCCESS,
              "",
              dump.data,
            ),
          );
        }
        return dump;
      }
    } else {
      final Resources<List<Contacts>> dump = await blockListDao!.getAll();
      if (!streamControllerContactList.isClosed) {
        streamControllerContactList.sink.add(
          Resources(
            Status.SUCCESS,
            "",
            dump.data,
          ),
        );
      }
      return dump;
    }
  }

  Future<dynamic> doSearchBlockContact(
    String query,
    StreamController<Resources<List<Contacts>>> streamControllerContactList,
  ) async {
    if (query.isNotEmpty) {
      if (query.contains("+")) {
        Resources<List<Contacts>> result = await blockListDao!.getAll(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "number",
              RegExp(
                "\\$query",
                caseSensitive: false,
              ),
            ),
          ),
        );

        if (result.data!.isNotEmpty) {
          sinkContactEdgesStream(streamControllerContactList, result);
        } else {
          final CountryCode countryCode = Utils.checkCountryCodeExist(
              query, (await countryDao!.getAll()).data!)!;

          if (await Utils.checkValidPhoneNumber(countryCode, query)) {
            if (!Config.psSupportedEmergencyNumberMap.containsKey(query)) {
              final List<Contacts> listHolder = [];
              listHolder.add(
                Contacts(
                  check: false,
                  workspaceId: getDefaultWorkspace(),
                  country: "",
                  blocked: false,
                  name: query,
                  number: query,
                  // dndEnabled: false,
                  // dndMissed: false,
                  dndInfo: DndInfo(),
                  notes: [],
                  tags: [],
                  visibility: false,
                  email: "",
                ),
              );
              result =
                  Resources<List<Contacts>>(Status.SUCCESS, "", listHolder);
            } else {
              result = Resources<List<Contacts>>(Status.SUCCESS, "", []);
            }
          } else {
            result = Resources<List<Contacts>>(Status.SUCCESS, "", []);
          }
          sinkContactEdgesStream(streamControllerContactList, result);
          sinkContactEdgesStream(streamControllerContactList, result);
        }
      } else {
        final Resources<List<Contacts>> result = await blockListDao!.getAll(
          finder: Finder(
            filter: Filter.or(
              [
                Filter.matchesRegExp(
                  "name",
                  RegExp(
                    query,
                    caseSensitive: false,
                  ),
                ),
                Filter.matchesRegExp(
                  "number",
                  RegExp(
                    query,
                    caseSensitive: false,
                  ),
                ),
              ],
            ),
          ),
        );
        sinkContactEdgesStream(streamControllerContactList,
            Resources<List<Contacts>>(Status.SUCCESS, "", result.data));
      }
    } else {
      final Resources<List<Contacts>> result = await blockListDao!.getAll();
      sinkContactEdgesStream(streamControllerContactList,
          Resources<List<Contacts>>(Status.SUCCESS, "", result.data));
    }
  }
}
