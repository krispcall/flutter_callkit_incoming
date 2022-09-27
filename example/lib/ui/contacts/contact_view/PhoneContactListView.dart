import "dart:convert";

import "package:azlistview/azlistview.dart";
import "package:contacts_service/contacts_service.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:lpinyin/lpinyin.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContact.dart";
import "package:mvp/viewObject/model/addContact/UploadPhoneContactResponse.dart";
import "package:mvp/viewObject/model/contactDetail/DefaultCountryCode.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:provider/provider.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";

class PhoneContactListView extends StatefulWidget {
  const PhoneContactListView({Key? key, this.onSuccess}) : super(key: key);

  final Function? onSuccess;

  @override
  _PhoneContactListView createState() => _PhoneContactListView();
}

class _PhoneContactListView extends State<PhoneContactListView> {
  List<PhoneContact> contactsData = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  int countContactSelected = 0;
  bool selectAll = false;

  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;
  ValueHolder? valueHolder;
  List<CountryCode>? countryCodeList;
  CountryCode? selectedCountryCode;
  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  void initState() {
    super.initState();

    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);
    selectedCountryCode = countryListProvider!.getDefaultCountryCode();
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(
        contactRepository: contactRepository, valueHolder: valueHolder);

    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    loginWorkspaceProvider = LoginWorkspaceProvider(
      loginWorkspaceRepository: loginWorkspaceRepository,
      valueHolder: valueHolder,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      countryCodeList = await countryListProvider!.getCountryListFromDb()
          as List<CountryCode>;
      getDeviceContacts();
      countryCodeAccWorkSpace();
    });
  }

  ///Check is share preferences is created or not if not create pref first
  Future<void> countryCodeAccWorkSpace() async {
    final List<DefaultCountryCode> defaultCountryCodeListAccWorkSpace = [];
    final List<LoginWorkspace>? listLoginWorkspace =
        loginWorkspaceRepository!.getWorkspaceList();

    if (listLoginWorkspace!.isNotEmpty) {
      for (int i = 0; i < listLoginWorkspace.length; i++) {
        defaultCountryCodeListAccWorkSpace.add(
          DefaultCountryCode(
            workspaceId: listLoginWorkspace[i].id,
            workspaceName: listLoginWorkspace[i].title,
          ),
        );
      }
    }

    if (PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_DEFAULT_COUNTRY_CODE_LIST) ==
        null) {
      PsSharedPreferences.instance!.shared!.setString(
          Const.VALUE_DEFAULT_COUNTRY_CODE_LIST,
          jsonEncode(defaultCountryCodeListAccWorkSpace));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///To upload data to server
  Future<void> uploadContactData(CountryCode countryCode) async {
    final List<PhoneContact> selectedUserData = [];
    for (int i = 0; i < contactsData.length; i++) {
      if (contactsData[i].isSelected!) {
        if (contactsData[i].number!.contains("+")) {
          final number = contactsData[i]
              .number!
              .replaceAll(" ", "")
              .replaceAll("[^\\p{ASCII}]", "")
              .replaceAll("-", "");
          selectedUserData.add(
            PhoneContact(
              number: number,
              fullName: contactsData[i].fullName,
              isSelected: true,
            ),
          );
        } else {
          final number = contactsData[i]
              .number!
              .replaceAll(" ", "")
              .replaceAll("[^\\p{ASCII}]", "")
              .replaceAll("-", "");
          selectedUserData.add(PhoneContact(
              number: "${countryCode.dialCode}$number",
              fullName: contactsData[i].fullName,
              isSelected: true));
        }
      }
    }

    if (await Utils.checkInternetConnectivity()) {
      showLoadingDialog(context, super.widget);
      final Resources<UploadPhoneContactResponse> data = await contactsProvider!
              .uploadPhoneContact(
                  UploadPhoneContact(contacts: selectedUserData))
          as Resources<UploadPhoneContactResponse>;
      if (data.status == Status.SUCCESS) {
        // contactsProvider.doEmptyAllContactApiCall();
        // contactsProvider.doAllContactApiCall();
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        final UploadBulkContacts bulkContacts = data.data!.uploadBulkContacts!;

        showImportContactDialog(context, super.widget, bulkContacts);
        widget.onSuccess!(true);
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Utils.showToastMessage(data.message!);
      }
    } else {
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

  ///Return CountryCode according to workspace
  CountryCode getCurrentWorkSpaceCountryCode() {
    ///Getting current workspace
    final LoginWorkspace currentWorkSpace = LoginWorkspace.fromJson(jsonDecode(
            PsSharedPreferences.instance!.shared!
                .getString(Const.VALUE_HOLDER_WORKSPACE_DETAIL)!)
        as Map<String, dynamic>);

    ///Country code
    CountryCode? countryCode = CountryCode();

    ///List of all workspace in users which is saved
    final listOfWorkSpace = jsonDecode(PsSharedPreferences.instance!.shared!
        .getString(Const.VALUE_DEFAULT_COUNTRY_CODE_LIST)!);

    for (int i = 0; i < int.parse(listOfWorkSpace.length.toString()); i++) {
      if (listOfWorkSpace[i]["countryCode"] != null) {
        if (listOfWorkSpace[i]["workspaceId"] == currentWorkSpace.id) {
          final DefaultCountryCode listOfWorkSpace1 =
              DefaultCountryCode.fromJson(
                  listOfWorkSpace[i] as Map<String, dynamic>);
          countryCode = listOfWorkSpace1.countryCode;
          break;
        }
      }
    }

    if (countryCode!.id == null) {
      showCountryCodeSelectorDialog(
          context, countryCodeList, selectedCountryCode,
          onSelectCountryCode: (v) {
        countryCode = v as CountryCode;

        final List<DefaultCountryCode> defaultCountryCodeListTemp = [];
        for (int i = 0; i < int.parse(listOfWorkSpace.length.toString()); i++) {
          if (listOfWorkSpace[i]["workspaceId"] == currentWorkSpace.id) {
            defaultCountryCodeListTemp.add(DefaultCountryCode(
                workspaceId: listOfWorkSpace[i]["workspaceId"] as String,
                workspaceName: listOfWorkSpace[i]["workspaceName"] as String,
                countryCode: v));
          } else {
            final DefaultCountryCode listOfWorkSpace1 =
                DefaultCountryCode.fromJson(
                    listOfWorkSpace[i] as Map<String, dynamic>);
            final CountryCode? cCode = listOfWorkSpace1.countryCode;

            defaultCountryCodeListTemp.add(DefaultCountryCode(
                workspaceId: listOfWorkSpace[i]["workspaceId"] as String,
                workspaceName: listOfWorkSpace[i]["workspaceName"] as String,
                countryCode: cCode));
          }
        }

        PsSharedPreferences.instance!.shared!.setString(
            Const.VALUE_DEFAULT_COUNTRY_CODE_LIST,
            jsonEncode(defaultCountryCodeListTemp));

        uploadContactData(countryCode!);
      });
    } else {
      uploadContactData(countryCode);
    }
    return countryCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space16.r),
          topRight: Radius.circular(Dimens.space16.r),
        ),
      ),
      height: ScreenUtil().screenHeight - Dimens.space50.h,
      width: MediaQuery.of(context).size.width.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          toolbar(
            context,
            title: Utils.getString("importContact"),
            lastButtonText: Utils.getString("next"),
            leadingButtonText: Utils.getString("cancel"),
            onNext: () async {
              if (contactsData.isNotEmpty) {
                var isSelected = false;
                for (int i = 0; i < contactsData.length; i++) {
                  if (contactsData[i].isSelected!) {
                    isSelected = true;
                  }
                }
                if (isSelected) {
                  getCurrentWorkSpaceCountryCode();
                } else {
                  Utils.showToastMessage(Utils.getString("selectContact"));
                }
              } else {
                Utils.showToastMessage(Utils.getString("noContactToUpload"));
              }
            },
          ),
          Divider(
            height: Dimens.space1,
            thickness: Dimens.space1,
            color: CustomColors.mainDividerColor,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space10.h,
                Dimens.space0, Dimens.space10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space30.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Row(
                      children: [
                        CustomCheckBox(
                          width: Dimens.space20,
                          height: Dimens.space20,
                          boxFit: BoxFit.contain,
                          iconUrl: Icons.fiber_manual_record,
                          iconColor: CustomColors.white!,
                          selectedColor: CustomColors.loadingCircleColor,
                          unSelectedColor: CustomColors.textQuaternaryColor,
                          isChecked: selectAll,
                          iconSize: Dimens.space10,
                          assetHeight: Dimens.space10,
                          assetWidth: Dimens.space10,
                          onCheckBoxTap: (value) {
                            setState(() {
                              if (selectAll) {
                                selectAll = false;
                              } else {
                                selectAll = true;
                              }
                            });

                            if (selectAll) {
                              for (int i = 0; i < contactsData.length; i++) {
                                setState(() {
                                  contactsData[i].isSelected = true;
                                  selectAll = true;
                                  countContactSelected = contactsData.length;
                                });
                              }
                            } else {
                              for (int i = 0; i < contactsData.length; i++) {
                                setState(() {
                                  contactsData[i].isSelected = false;
                                  countContactSelected = 0;
                                  selectAll = false;
                                });
                              }
                            }
                          },
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space10.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Utils.getScreenWidth(context).w * 0.1,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("all"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: CustomColors.black,
                                      fontFamily: Config.manropeRegular,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space15.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : "$countContactSelected selected",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: CustomColors.black,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return getListItem(context, contactsData, onPress: (v) {
                final int indexData = int.parse(v["index"] as String);
                var isClicked = false;
                if (v["isClicked"] == "true") {
                  isClicked = true;
                }
                setState(() {
                  contactsData[indexData].isSelected = isClicked;
                });

                var count = 0;
                for (int i = 0; i < contactsData.length; i++) {
                  if (contactsData[i].isSelected!) {
                    count++;
                  }
                }
                if (count == contactsData.length) {
                  setState(() {
                    selectAll = true;
                  });
                } else {
                  setState(() {
                    selectAll = false;
                  });
                }
                setState(() {
                  countContactSelected = count;
                });
              });
            }),
          ),
        ],
      ),
    );
  }

  ///Get data from mobile and filter
  Future<void> getDeviceContacts() async {
    final List<PhoneContact> contactsData = [];

    final contacts = await ContactsService.getContacts(
      withThumbnails: false,
      iOSLocalizedLabels: false,
    );

    for (final contact in contacts) {
      var itemsPhones = "";
      for (final i in contact.phones!) {
        itemsPhones = i.value ?? "";
      }

      if (itemsPhones.isNotEmpty) {
        contactsData.add(
          PhoneContact(
            number: itemsPhones,
            fullName: contact.displayName ?? "",
            isSelected: false,
          ),
        );
      }
      // ContactsService.getAvatar(contact).then((avatar)
      // {
      //   if (avatar == null) return;
      //
      //   setState(() => contact.avatar = avatar);
      // });
    }
    contactsData.sort((a, b) =>
        a.fullName!.toLowerCase().compareTo(b.fullName!.toLowerCase()));

    setState(() {
      this.contactsData = contactsData;
    });

    if (contactsData.isNotEmpty) {
      for (int i = 0, length = contactsData.length; i < length; i++) {
        final String pinyin = PinyinHelper.getPinyinE(
          contactsData[i].fullName != null &&
                  contactsData[i].fullName!.isNotEmpty
              ? contactsData[i].fullName!
              : contactsData[i].number!,
        );
        final String tag = pinyin.substring(0, 1).toUpperCase();
        contactsData[i].namePinyin = pinyin;
        if (RegExp("[A-Z]").hasMatch(tag)) {
          contactsData[i].tagIndex = tag;
        } else {
          contactsData[i].tagIndex = "#";
        }
      }
      // A-Z sort.
      SuspensionUtil.sortListBySuspensionTag(contactsData);
      // show sus tag.
      SuspensionUtil.setShowSuspensionStatus(contactsData);
    }

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }
}

///toolbar
@swidget
Widget toolbar(
  BuildContext context, {
  Function? onNext,
  required String title,
  required String leadingButtonText,
  required String lastButtonText,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space4.h,
            Dimens.space0.w, Dimens.space4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.space14.r),
          ),
        ),
        width: Utils.getScreenWidth(context).w * 0.2,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: CustomColors.startButtonColor,
                size: Dimens.space20.r,
              ),
              Expanded(
                child: Container(
                  height: Dimens.space50.h,
                  alignment: FractionalOffset.center,
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : leadingButtonText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.loadingCircleColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            Config.checkOverFlow ? Const.OVERFLOW : title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontFamily: Config.manropeBold,
                  color: CustomColors.textPrimaryColor,
                  fontSize: Dimens.space18.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
      ),
      Container(
        alignment: FractionalOffset.centerRight,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space4.h,
            Dimens.space16.w, Dimens.space4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.space14.r),
          ),
        ),
        width: Utils.getScreenWidth(context).w * 0.2,
        child: TextButton(
          onPressed: () {
            onNext!();
          },
          style: TextButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: CustomColors.transparent,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.space0.r),
            ),
          ),
          child: Text(
            Config.checkOverFlow ? Const.OVERFLOW : lastButtonText,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: CustomColors.loadingCircleColor,
                  fontFamily: Config.manropeSemiBold,
                  fontSize: Dimens.space15.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
      ),
    ],
  );
}

///Show country code selector Dialog
Future<void> showCountryCodeSelectorDialog(BuildContext context,
    List<CountryCode>? countryCodeList, CountryCode? selectedCountryCode,
    {Function? onSelectCountryCode}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.space10.r),
        topRight: Radius.circular(Dimens.space10.r),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return CountryCodeSelectorDialog(
        countryCodeList: countryCodeList,
        selectedCountryCode: selectedCountryCode,
        onSelectCountryCode: (CountryCode countryCode) {
          onSelectCountryCode!(countryCode);
        },
      );
    },
  );
}

///Display view in list
@swidget
Widget getListItem(BuildContext context, List<PhoneContact> contactsData,
    {Function? onPress}) {
  if (contactsData != null) {
    return Container(
      color: CustomColors.white,
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      padding: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      child: contactsData.isNotEmpty
          ? AzListView(
              data: contactsData,
              itemCount: contactsData.length,
              physics: const AlwaysScrollableScrollPhysics(),
              indexBarData: SuspensionUtil.getTagIndexList(null),
              indexBarMargin: EdgeInsets.fromLTRB(Dimens.space0.w,
                  Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              indexBarOptions: const IndexBarOptions(
                needRebuild: true,
                indexHintAlignment: Alignment.centerLeft,
              ),
              susItemBuilder: (context, i) {
                return Container(
                  width: MediaQuery.of(context).size.width.sw,
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    color: CustomColors.bottomAppBarColor,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width.sw,
                    padding: EdgeInsets.fromLTRB(Dimens.space20.w,
                        Dimens.space5.h, Dimens.space20.w, Dimens.space5.h),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : contactsData[i].getSuspensionTag(),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CustomColors.textTertiaryColor,
                        fontFamily: Config.manropeBold,
                        fontSize: Dimens.space14.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      Dimens.space0.h,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    if (contactsData[index].isSelected!) {
                      final Map<String, String> map1 = {
                        "index": index.toString(),
                        "isClicked": false.toString()
                      };
                      onPress!(map1);
                    } else {
                      final Map<String, String> map1 = {
                        "index": index.toString(),
                        "isClicked": true.toString()
                      };
                      onPress!(map1);
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space30.w,
                          Dimens.space8.h,
                          Dimens.space0.w,
                          Dimens.space8.h,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        alignment: Alignment.center,
                        child: CustomCheckBox(
                          width: Dimens.space20,
                          height: Dimens.space20,
                          boxFit: BoxFit.contain,
                          iconUrl: Icons.check,
                          iconColor: CustomColors.white,
                          selectedColor: CustomColors.loadingCircleColor,
                          unSelectedColor: CustomColors.callInactiveColor,
                          iconSize: Dimens.space16,
                          outerCorner: Dimens.space6,
                          innerCorner: Dimens.space6,
                          assetHeight: Dimens.space20,
                          assetWidth: Dimens.space20,
                          isChecked: contactsData[index].isSelected,
                          onCheckBoxTap: (value) {
                            if (contactsData[index].isSelected!) {
                              final Map<String, String> map1 = {
                                "index": index.toString(),
                                "isClicked": false.toString()
                              };
                              onPress!(map1);
                            } else {
                              final Map<String, String> map1 = {
                                "index": index.toString(),
                                "isClicked": true.toString()
                              };
                              onPress!(map1);
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space15.w,
                              Dimens.space8.h,
                              Dimens.space15.w,
                              Dimens.space8.h),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contactsData[index].fullName!,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlainAssetImageHolder(
                  assetUrl: "assets/images/empty_contact.png",
                  width: Dimens.space152,
                  height: Dimens.space152,
                  assetWidth: Dimens.space152,
                  assetHeight: Dimens.space152,
                  boxFit: BoxFit.contain,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  iconSize: Dimens.space152,
                  iconUrl: CustomIcon.icon_call,
                  iconColor: CustomColors.white,
                  boxDecorationColor: CustomColors.white,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space40.w,
                      Dimens.space20.h, Dimens.space40.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("noContacts"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: Dimens.space20.sp,
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
              ],
            ),
    );
  } else {
    return Text(
      Config.checkOverFlow ? Const.OVERFLOW : Utils.getString("credits"),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: Dimens.space20.sp,
            color: CustomColors.textPrimaryColor,
            fontFamily: Config.manropeBold,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
    );
  }
}

///Display on complete dialog
@swidget
Future<void> showImportContactDialog(BuildContext context,
    PhoneContactListView widget, UploadBulkContacts bulkContacts) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.space16.r),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
            Dimens.space16.w, Dimens.space0.h),
        child: SizedBox(
          height: Dimens.space334.h,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space232.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.space16.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Dimens.space60.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space2.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedAssetImageHolder(
                        assetUrl: "assets/images/check.png",
                        width: Dimens.space60,
                        height: Dimens.space60,
                        iconUrl: CustomIcon.icon_profile,
                        iconColor: CustomColors.callInactiveColor,
                        iconSize: Dimens.space60,
                        boxDecorationColor: CustomColors.mainDividerColor,
                        outerCorner: Dimens.space50,
                        innerCorner: Dimens.space0,
                        containerAlignment: Alignment.bottomCenter,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("importCompleted"),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.black,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: "Your "),
                            TextSpan(
                                text: "${bulkContacts.data!.savedRecords}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                              text:
                                  " contacts importing is complete.You can now start using contact from Krispcall.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.space16.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: Dimens.space48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.space16.r),
                  ),
                  child: Center(
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("close"),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.space32.h),
            ],
          ),
        ),
      );
    },
  );
}

///Display on complete dialog
@swidget
Future<void> showLoadingDialog(
    BuildContext context, PhoneContactListView widget) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.space16.r),
    ),
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
            Dimens.space16.w, Dimens.space0.h),
        child: SizedBox(
          height: Dimens.space334.h,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: Dimens.space232.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimens.space16.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Dimens.space60.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space2.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedAssetImageHolder(
                        assetUrl: "assets/images/folder.png",
                        width: Dimens.space60,
                        height: Dimens.space60,
                        iconUrl: CustomIcon.icon_profile,
                        iconColor: CustomColors.callInactiveColor,
                        iconSize: Dimens.space60,
                        boxDecorationColor: CustomColors.mainDividerColor,
                        outerCorner: Dimens.space50,
                        innerCorner: Dimens.space0,
                        containerAlignment: Alignment.bottomCenter,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("contactImporting"),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.black,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("contactUploading"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      child: LinearProgressIndicator(
                        backgroundColor: CustomColors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CustomColors.mainColor!),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.space16.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: Dimens.space48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimens.space16.r),
                  ),
                  child: Center(
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("close"),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.space32.h),
            ],
          ),
        ),
      );
    },
  );
}

///Country Selector dialog
class CountryCodeSelectorDialog extends StatefulWidget {
  const CountryCodeSelectorDialog({
    Key? key,
    this.countryCodeList,
    this.selectedCountryCode,
    this.onSelectCountryCode,
  }) : super(key: key);
  final List<CountryCode>? countryCodeList;
  final Function(CountryCode)? onSelectCountryCode;
  final CountryCode? selectedCountryCode;

  @override
  _CountryCodeSelectorDialogState createState() =>
      _CountryCodeSelectorDialogState();
}

class _CountryCodeSelectorDialogState extends State<CountryCodeSelectorDialog>
    with SingleTickerProviderStateMixin {
  late CountryRepository countryRepository;
  late CountryListProvider countryListProvider;

  late ValueHolder valueHolder;
  late AnimationController animationController;

  final TextEditingController controllerSearchCountry = TextEditingController();
  final _debounce = DeBouncer(milliseconds: 500);
  final List<CountryCode> _searchResult = [];
  CountryCode? countryCode;
  int positionColor = -1;
  final ScrollController scrollController = ScrollController();

  int start = 0;
  int end = 20;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    for (final element in widget.countryCodeList!) {
      element.flagUri!.replaceRange(0, 15, "assets/flags/");
    }

    _searchResult.addAll(widget.countryCodeList!);

    controllerSearchCountry.addListener(() {
      _debounce.run(() {
        if (controllerSearchCountry.text.isEmpty) {
          _searchResult.clear();
          _searchResult.addAll(widget.countryCodeList!.getRange(start, end));
          setState(() {});
        } else {
          _searchResult.clear();
          _searchResult.addAll(widget.countryCodeList!
              .where(
                (country) =>
                    country.name!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()) ||
                    country.code!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()) ||
                    country.dialCode!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()),
              )
              .toList());
          setState(() {});
        }
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          start = end;
          end += 10;
          _searchResult.addAll(widget.countryCodeList!.getRange(start, end));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    countryRepository = Provider.of<CountryRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return ChangeNotifierProvider<CountryListProvider>(
      lazy: false,
      create: (BuildContext context) {
        countryListProvider =
            CountryListProvider(countryListRepository: countryRepository);
        return countryListProvider;
      },
      child: Consumer<CountryListProvider>(builder:
          (BuildContext context, CountryListProvider? provider, Widget? child) {
        if (widget.countryCodeList != null &&
            widget.countryCodeList!.isNotEmpty) {
          return Container(
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: MediaQuery.of(context).size.width.w,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Dimens.space0.h,
              Dimens.space0.w,
              Dimens.space0.h,
            ),
            padding: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Dimens.space0.h,
              Dimens.space0.w,
              Dimens.space0.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  toolbar(
                    context,
                    title: Utils.getString("defaultCountryCode"),
                    lastButtonText: Utils.getString("done"),
                    leadingButtonText: Utils.getString("back"),
                    onNext: () {
                      if (countryCode != null) {
                        widget.onSelectCountryCode!(countryCode!);
                        Navigator.of(context).pop();
                      } else {
                        Utils.showToastMessage(
                            Utils.getString("selectCountryCode"));
                      }
                    },
                  ),
                  Divider(
                    height: Dimens.space1,
                    thickness: Dimens.space1,
                    color: CustomColors.mainDividerColor,
                  ),
                  Container(
                    height:
                        MediaQuery.of(context).size.height.h + Dimens.space80.h,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space20.h,
                            Dimens.space16.w,
                            Dimens.space20.h,
                          ),
                          alignment: Alignment.center,
                          height: Dimens.space52.h,
                          child: TextField(
                            controller: controllerSearchCountry,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textSenaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimens.space16.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              filled: true,
                              prefixIconConstraints: BoxConstraints(
                                minWidth: Dimens.space40.w,
                                maxWidth: Dimens.space40.w,
                                maxHeight: Dimens.space20.h,
                                minHeight: Dimens.space20.h,
                              ),
                              prefixIcon: Container(
                                alignment: Alignment.center,
                                width: Dimens.space20.w,
                                height: Dimens.space20.w,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space15.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space0.h),
                                child: Icon(
                                  CustomIcon.icon_search,
                                  size: Dimens.space16.w,
                                  color: CustomColors.textTertiaryColor,
                                ),
                              ),
                              fillColor: CustomColors.baseLightColor,
                              hintText: Utils.getString("selectCountryCode"),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space16.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: _searchResult.length,
                            itemBuilder: (context, position) {
                              return Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space16.w,
                                            Dimens.space14.h,
                                            Dimens.space16.w,
                                            Dimens.space14.h),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor:
                                            widget.selectedCountryCode!.code ==
                                                    _searchResult[position].code
                                                ? CustomColors.baseLightColor
                                                : CustomColors.transparent,
                                      ),
                                      onPressed: () {
                                        widget.onSelectCountryCode!(
                                            _searchResult[position]);
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space12.w,
                                                Dimens.space0.h),
                                            alignment: Alignment.center,
                                            child: RoundedNetworkImageHolder(
                                              imageUrl: PSApp
                                                      .config!.countryLogoUrl! +
                                                  _searchResult[position]
                                                      .flagUri!,
                                              width: Dimens.space24,
                                              height: Dimens.space24,
                                              boxFit: BoxFit.contain,
                                              containerAlignment:
                                                  Alignment.bottomCenter,
                                              iconUrl: CustomIcon.icon_gallery,
                                              iconColor: CustomColors.grey,
                                              iconSize: Dimens.space20,
                                              boxDecorationColor: CustomColors
                                                  .mainBackgroundColor,
                                              outerCorner: Dimens.space0,
                                              innerCorner: Dimens.space0,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : "${_searchResult[position].dialCode} (${_searchResult[position].name}) ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal)
                                                    .copyWith(
                                                      color: widget
                                                                  .selectedCountryCode!
                                                                  .id ==
                                                              _searchResult[
                                                                      position]
                                                                  .id
                                                          ? CustomColors
                                                              .textPrimaryColor
                                                          : CustomColors
                                                              .textPrimaryLightColor,
                                                      fontFamily: Config
                                                          .manropeSemiBold,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize:
                                                          Dimens.space16.sp,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: CustomColors.callInactiveColor,
                                    height: Dimens.space1.h,
                                    thickness: Dimens.space1.h,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - Dimens.space100.h,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: SpinKitCircle(
              color: CustomColors.mainColor,
            ),
          );
        }
      }),
    );
  }
}
