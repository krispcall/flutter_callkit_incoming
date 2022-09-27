/*
 * *
 *  * Created by Kedar on 7/29/21 2:35 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 3:33 PM
 *
 */

import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";

/*
 * *
 *  * Created by Kedar on 7/28/21 2:35 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/28/21 2:35 PM
 *
 */

class OverViewWidget extends StatefulWidget {
  const OverViewWidget({
    Key? key,
    required this.onUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final VoidCallback onUpdateCallback;

  @override
  OverViewWidgetState createState() => OverViewWidgetState();
}

class OverViewWidgetState extends State<OverViewWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  TextEditingController controllerWorkspaceName = TextEditingController();
  final FocusNode focusWorkspaceName = FocusNode();
  final workspaceNameKey = GlobalKey<FormState>();

  LoginWorkspaceProvider? workspaceProvider;
  LoginWorkspaceRepository? workspaceRepository;
  ValueHolder? valueHolder;

  File? _image;
  final _picker = ImagePicker();
  File? _selectedFile;
  String? selectedFilePath;
  bool? isImageSelected = false;

  Future<void> _askPermissionStorage() async {
    await [Permission.storage].request().then(_onStatusRequested);
  }

  Future<void> _askPermissionPhotos() async {
    await [Permission.photos].request().then(_onStatusRequested);
  }

  void _onStatusRequested(Map<Permission, PermissionStatus> status) {
    Permission perm;
    if (Platform.isIOS) {
      perm = Permission.photos;
    } else {
      perm = Permission.storage;
    }
    if (status[perm] != PermissionStatus.granted) {
      if (Platform.isIOS) {
        openAppSettings();
      }
    } else {
      _getImage(ImageSource.gallery);
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });

    if (_image != null) {
      final File? cropped = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Cropper",
          toolbarColor: CustomColors.mainColor,
          toolbarWidgetColor: CustomColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      setState(() {
        if (cropped != null) {
          if (_selectedFile != null && _selectedFile!.existsSync()) {
            _selectedFile!.deleteSync();
          }
          _selectedFile = cropped;
          isImageSelected = true;
          selectedFilePath = _selectedFile!.path;
        }

        // delete image camera
        if (source.toString() == "ImageSource.camera" && _image!.existsSync()) {
          _image!.deleteSync();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    workspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    animationController =
        AnimationController(vsync: this, duration: Config.animation_duration);
    controllerWorkspaceName.text =
        workspaceRepository!.getWorkspaceDetail() != null &&
                workspaceRepository!.getWorkspaceDetail()!.title != null &&
                workspaceRepository!.getWorkspaceDetail()!.title!.isNotEmpty
            ? workspaceRepository!.getWorkspaceDetail()!.title!
            : "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _requestPop() {
    CustomAppBar.changeStatusColor(CustomColors.mainColor!);
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context);
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomAppBar<LoginWorkspaceProvider>(
          titleWidget: PreferredSize(
            preferredSize:
                Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: CustomColors.white,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space8.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: TextButton(
                      onPressed: _requestPop,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CustomIcon.icon_arrow_left,
                            color: CustomColors.loadingCircleColor,
                            size: Dimens.space22.w,
                          ),
                          Expanded(
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("cancel"),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: CustomColors.loadingCircleColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("overview"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  ),
                ),
              ],
            ),
          ),
          leadingWidget: null,
          elevation: 1,
          onIncomingTap: () {
            widget.onIncomingTap();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap();
          },
          initProvider: () {
            return LoginWorkspaceProvider(
                loginWorkspaceRepository: workspaceRepository,
                valueHolder: valueHolder);
          },
          onProviderReady: (LoginWorkspaceProvider provider) async {
            workspaceProvider = provider;
          },
          builder: (BuildContext? context, LoginWorkspaceProvider? provider,
              Widget? child) {
            animationController!.forward();
            return AnimatedBuilder(
              animation: animationController!,
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: const Interval(
                        0.5 * 1,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0,
                        100 *
                            (1.0 -
                                Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: animationController!,
                                        curve: const Interval(0.5 * 1, 1.0,
                                            curve: Curves.fastOutSlowIn)))
                                    .value),
                        0.0),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space8.h, Dimens.space16.w, Dimens.space0.h),
                      height: ScreenUtil().screenHeight * 0.80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimens.space16.w),
                          topLeft: Radius.circular(Dimens.space16.w),
                        ),
                        color: CustomColors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space36.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: Dimens.space90.w,
                                  height: Dimens.space90.w,
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
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        child: isImageSelected!
                                            ? PlainFileImageHolder(
                                                fileUrl:
                                                    (selectedFilePath != null &&
                                                            selectedFilePath!
                                                                .isNotEmpty)
                                                        ? selectedFilePath!
                                                        : "",
                                                width: Dimens.space80,
                                                height: Dimens.space80,
                                                outerCorner: Dimens.space20,
                                                innerCorner: Dimens.space20,
                                                iconSize: Dimens.space40,
                                                iconUrl:
                                                    CustomIcon.icon_profile,
                                                iconColor: CustomColors
                                                    .mainDividerColor!,
                                                boxDecorationColor: CustomColors
                                                    .bottomAppBarColor!,
                                              )
                                            : workspaceProvider!
                                                            .getWorkspaceDetail()
                                                            .photo !=
                                                        null &&
                                                    workspaceProvider!
                                                        .getWorkspaceDetail()
                                                        .photo!
                                                        .isNotEmpty
                                                ? RoundedNetworkImageTextHolder(
                                                    imageUrl: workspaceProvider!
                                                        .getWorkspaceDetail()
                                                        .photo!
                                                        .trim(),
                                                    width: Dimens.space80,
                                                    height: Dimens.space80,
                                                    text: workspaceProvider!
                                                        .getWorkspaceDetail()
                                                        .title!
                                                        .characters
                                                        .first
                                                        .toUpperCase(),
                                                    corner: Dimens.space20,
                                                    iconSize: Dimens.space40,
                                                    fontSize: Dimens.space24,
                                                    textColor: CustomColors
                                                        .textPrimaryColor!,
                                                    iconUrl:
                                                        CustomIcon.icon_profile,
                                                    iconColor: CustomColors
                                                        .textPrimaryColor!,
                                                    fontFamily:
                                                        Config.heeboExtraBold,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .bottomAppBarColor!,
                                                  )
                                                : PlainAssetImageHolder(
                                                    assetUrl:
                                                        "assets/images/icon_upload_text.png",
                                                    width: Dimens.space80,
                                                    height: Dimens.space80,
                                                    assetWidth: Dimens.space80,
                                                    assetHeight: Dimens.space80,
                                                    boxFit: BoxFit.contain,
                                                    iconUrl: CustomIcon
                                                        .icon_plus_rounded,
                                                    iconColor:
                                                        CustomColors.white!,
                                                    iconSize: Dimens.space24,
                                                    outerCorner: Dimens.space12,
                                                    innerCorner: Dimens.space12,
                                                    boxDecorationColor:
                                                        CustomColors
                                                            .transparent!,
                                                    onTap: () {
                                                      if (Platform.isIOS) {
                                                        _askPermissionPhotos();
                                                      } else {
                                                        _askPermissionStorage();
                                                      }
                                                    },
                                                  ),
                                      ),
                                      if (workspaceProvider!
                                          .getAllowWorkspaceUpdateProfilePicture())
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: PlainAssetImageHolder(
                                            assetUrl:
                                                "assets/images/icon_upload.png",
                                            width: Dimens.space24,
                                            height: Dimens.space24,
                                            assetWidth: Dimens.space24,
                                            assetHeight: Dimens.space24,
                                            boxFit: BoxFit.contain,
                                            iconUrl:
                                                CustomIcon.icon_plus_rounded,
                                            iconColor: CustomColors.white!,
                                            iconSize: Dimens.space24,
                                            outerCorner: Dimens.space12,
                                            innerCorner: Dimens.space12,
                                            boxDecorationColor:
                                                CustomColors.transparent!,
                                            onTap: () {
                                              if (Platform.isIOS) {
                                                _askPermissionPhotos();
                                              } else {
                                                _askPermissionStorage();
                                              }
                                            },
                                          ),
                                        )
                                      else
                                        Container(),
                                    ],
                                  ),
                                ),
                                if (workspaceProvider!
                                        .getAllowWorkspaceUpdateProfilePicture() &&
                                    selectedFilePath != null &&
                                    selectedFilePath!.isNotEmpty)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space10),
                                    child: TextButton(
                                      onPressed: () {
                                        selectedFilePath = "";
                                        isImageSelected = false;
                                        setState(() {});
                                      },
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : Utils.getString("remove"),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: Dimens.space15.sp,
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontFamily:
                                                  Config.manropeSemiBold,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space36.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: CustomTextForm(
                              focusNode: focusWorkspaceName,
                              validationKey: workspaceNameKey,
                              controller: controllerWorkspaceName,
                              context: context,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              validatorErrorText: Utils.getString("required"),
                              focusColor: focusWorkspaceName.hasFocus
                                  ? CustomColors.white!
                                  : CustomColors.baseLightColor!,
                              inputFontColor: CustomColors.textSenaryColor!,
                              inputFontSize: Dimens.space16,
                              inputFontStyle: FontStyle.normal,
                              inputFontFamily: Config.heeboRegular,
                              hint: "",
                              hintFontColor: CustomColors.textQuaternaryColor!,
                              hintFontFamily: Config.heeboRegular,
                              hintFontStyle: FontStyle.normal,
                              hintFontWeight: FontWeight.normal,
                              title: Utils.getString("workspaceName"),
                              titleFontColor: CustomColors.textSecondaryColor!,
                              titleFontFamily: Config.manropeBold,
                              titleFontSize: Dimens.space14,
                              titleFontStyle: FontStyle.normal,
                              titleFontWeight: FontWeight.normal,
                              readOnly: !workspaceProvider!
                                  .getAllowWorkspaceChangeName(),
                              autofocus: true,
                              validator: (value) {
                                if (value == "") {
                                  return Utils.getString("required");
                                } else if (controllerWorkspaceName.text.length <
                                    2) {
                                  return Utils.getString(
                                      "workSpaceNameMinLimitError");
                                } else if (controllerWorkspaceName.text.length >
                                    44) {
                                  return Utils.getString(
                                      "workSpaceNameMaxLimitError");
                                } else {
                                  return null;
                                }
                              },
                              changeFocus: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          if (workspaceProvider!
                                  .getAllowWorkspaceUpdateProfilePicture() &&
                              workspaceProvider!.getAllowWorkspaceChangeName())
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space24.h,
                                  Dimens.space0.w,
                                  Dimens.space34.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: RoundedButtonWidget(
                                width: double.maxFinite,
                                buttonBackgroundColor: CustomColors.mainColor!,
                                buttonTextColor: CustomColors.white!,
                                corner: Dimens.space10,
                                buttonBorderColor: CustomColors.mainColor!,
                                buttonFontFamily: Config.manropeSemiBold,
                                buttonText: Utils.getString("saveChanges"),
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  final bool connectivity =
                                      await Utils.checkInternetConnectivity();
                                  if (connectivity) {
                                    if (controllerWorkspaceName.text ==
                                        workspaceProvider!
                                            .getWorkspaceDetail()
                                            .title) {
                                      if (selectedFilePath == null ||
                                          selectedFilePath!.isEmpty) {
                                        showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: Utils.getString(
                                                  "Please change image or workspace name."),
                                            );
                                          },
                                        );
                                      } else {
                                        doWorkspaceImageEditApiCall();
                                      }
                                    } else {
                                      if (selectedFilePath == null ||
                                          selectedFilePath!.isEmpty) {
                                        doWorkspaceNameEditApiCall();
                                      } else {
                                        doWorkspaceEditApiCal();
                                      }
                                    }
                                  } else {
                                    if (!mounted) return;
                                    Utils.showWarningToastMessage(
                                        Utils.getString("noInternet"), context);
                                  }
                                },
                              ),
                            )
                          else
                            Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> doWorkspaceEditApiCal() async {
    final password = workspaceNameKey.currentState!.validate();
    if (password) {
      await PsProgressDialog.showDialog(context);
      final Resources<String> resource = await workspaceProvider!
          .doEditWorkspaceNameApiCall(controllerWorkspaceName.text);
      if (resource.data != null) {
        final Resources<String> response = await workspaceProvider!
            .doEditWorkspaceImageApiCall(Utils.convertImageToBase64String(
                "photoUpload", File(selectedFilePath!)));

        if (response.data != null) {
          await PsProgressDialog.dismissDialog();
          Utils.showToastMessage(Utils.getString("workspaceImageUpdated"));
          widget.onUpdateCallback();
        } else {
          await PsProgressDialog.dismissDialog();
          Utils.showToastMessage(
              response.message ?? Utils.getString("workspaceImageUpdateError"));
        }
      } else {
        await PsProgressDialog.dismissDialog();
        Utils.showToastMessage(
            resource.message ?? Utils.getString("workspaceNameUpdateError"));
      }
    }
  }

  Future<void> doWorkspaceImageEditApiCall() async {
    await PsProgressDialog.showDialog(context);
    final Resources<String> response = await workspaceProvider!
        .doEditWorkspaceImageApiCall(Utils.convertImageToBase64String(
            "photoUpload", File(selectedFilePath!)));

    if (response.data != null) {
      await PsProgressDialog.dismissDialog();
      Utils.showToastMessage(Utils.getString("workspaceImageUpdated"));
      widget.onUpdateCallback();
    } else {
      await PsProgressDialog.dismissDialog();
      Utils.showToastMessage(
          response.message ?? Utils.getString("workspaceImageUpdateError"));
    }
  }

  Future<void> doWorkspaceNameEditApiCall() async {
    final password = workspaceNameKey.currentState!.validate();
    if (password) {
      await PsProgressDialog.showDialog(context);
      final Resources<String> response = await workspaceProvider!
          .doEditWorkspaceNameApiCall(controllerWorkspaceName.text);
      if (response.data != null) {
        await PsProgressDialog.dismissDialog();
        Utils.showToastMessage(Utils.getString("workspaceNameUpdated"));
        widget.onUpdateCallback();
      } else {
        await PsProgressDialog.dismissDialog();
        Utils.showToastMessage(
            response.message ?? Utils.getString("workspaceNameUpdateError"));
      }
    }
  }
}
