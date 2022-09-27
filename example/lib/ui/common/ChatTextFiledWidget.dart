import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/repository/MemberMessageDetailsRepository.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/ui/common/CounterWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/NoLeadingSpaceFormatter.dart";
import "package:mvp/utils/Utils.dart";

class ChatTextFieldWidgetWithIcon extends StatefulWidget {
  const ChatTextFieldWidgetWithIcon({
    Key? key,
    required this.onSendTap,
    required this.onMacrosTap,
    required this.textEditingController,
    required this.animationController,
    required this.isSendIconVisible,
    required this.onChanged,
    required this.listConversationEdge,
    this.customIcon,
    this.onFileSelectTap,
  }) : super(key: key);

  final Function onSendTap;
  final Function onMacrosTap;
  final Function? onFileSelectTap;
  final TextEditingController textEditingController;
  final AnimationController animationController;
  final IconData? customIcon;
  final bool isSendIconVisible;
  final Function(String) onChanged;
  final List<MessageDetailsObjectWithType>? listConversationEdge;

  @override
  _ChatTextFieldWidgetWithIconState createState() =>
      _ChatTextFieldWidgetWithIconState();
}

class _ChatTextFieldWidgetWithIconState
    extends State<ChatTextFieldWidgetWithIcon> {
  final FocusNode focusNode = FocusNode();

  int maxlines = 0;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space8.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
                  Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: CustomColors.baseLightColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.space12.w)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Dimens.space40.w,
                    height: Dimens.space40.w,
                    margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space6.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space20,
                      height: Dimens.space20,
                      iconUrl: CustomIcon.icon_macros,
                      iconColor: CustomColors.textSecondaryColor,
                      iconSize: Dimens.space20,
                      boxDecorationColor: CustomColors.transparent,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      imageUrl: "",
                      onTap: widget.onMacrosTap,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: widget.textEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: maxlines == 0 ? null : maxlines,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space14.sp,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.newline,
                      inputFormatters: [
                        NoLeadingSpaceFormatter(),
                        LengthLimitingTextInputFormatter(660),
                      ],
                      onChanged: (value) {
                        widget.onChanged(value);
                        if (value.length > 150) {
                          maxlines = 4;
                        } else {
                          maxlines = 0;
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(Dimens.space8.w,
                            Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space12.w)),
                        ),
                        filled: true,
                        fillColor: CustomColors.baseLightColor,
                        hintText: Utils.getString("typeYourMessage"),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(
                                color: CustomColors.textPrimaryLightColor,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space14.sp,
                                fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Container(
                    height: Dimens.space40.w,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space6.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: CounterWidget(
                      characterCount: widget.textEditingController.text.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !widget.isSendIconVisible,
            child: Container(
              width: Dimens.space40.w,
              height: Dimens.space40.w,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space6.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: RoundedNetworkImageHolder(
                width: Dimens.space44,
                height: Dimens.space44,
                iconUrl: CustomIcon.icon_message_send,
                iconColor: CustomColors.white,
                iconSize: Dimens.space16,
                boxDecorationColor: CustomColors.mainColor,
                outerCorner: Dimens.space300,
                innerCorner: Dimens.space300,
                imageUrl: "",
                onTap: widget.onSendTap,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        // isShowSticker = false;
      });
    }
  }
}

class MemberChatTextFieldWidgetWithIcon extends StatefulWidget {
  const MemberChatTextFieldWidgetWithIcon({
    Key? key,
    required this.onSendTap,
    required this.textEditingController,
    required this.animationController,
    required this.isSendIconVisible,
    required this.onChanged,
    required this.listConversationEdge,
    this.isFromMemberChatScreen = false,
    this.customIcon,
    this.onFileSelectTap,
  }) : super(key: key);

  final Function onSendTap;
  final Function? onFileSelectTap;
  final TextEditingController textEditingController;
  final AnimationController animationController;
  final IconData? customIcon;
  final bool isSendIconVisible;
  final Function(String) onChanged;
  final List<MemberMessageDetailsObjectWithType>? listConversationEdge;
  final bool isFromMemberChatScreen;

  @override
  _MemberChatTextFieldWidgetWithIconState createState() =>
      _MemberChatTextFieldWidgetWithIconState();
}

class _MemberChatTextFieldWidgetWithIconState
    extends State<MemberChatTextFieldWidgetWithIcon> {
  final FocusNode focusNode = FocusNode();

  int maxlines = 0;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("ListMemberConversation");
    // print(MemberMessageDetailsObjectWithType().toMapList(widget.listConversationEdge));
    return widget.listConversationEdge != null || widget.isFromMemberChatScreen
        ? Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h,
                Dimens.space0.w, Dimens.space8.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            color: CustomColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                        Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CustomColors.baseLightColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.space12.w),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: widget.textEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: maxlines == 0 ? null : maxlines,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: CustomColors.textPrimaryLightColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.newline,
                            inputFormatters: [
                              NoLeadingSpaceFormatter(),
                              LengthLimitingTextInputFormatter(660),
                            ],
                            onChanged: (value) {
                              widget.onChanged(value);
                              if (value.length > 150) {
                                maxlines = 4;
                              } else {
                                maxlines = 0;
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  Dimens.space16.w,
                                  Dimens.space0.h,
                                  Dimens.space16.w,
                                  Dimens.space0.h),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: Dimens.space0.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space12.w)),
                              ),
                              filled: true,
                              fillColor: CustomColors.baseLightColor,
                              hintText: Utils.getString("typeYourMessage"),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: CustomColors.textPrimaryLightColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space14.sp,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Container(
                          height: Dimens.space40.w,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space6.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          child: CounterWidget(
                            characterCount:
                                widget.textEditingController.text.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: !widget.isSendIconVisible,
                  child: Container(
                    width: Dimens.space40.w,
                    height: Dimens.space40.w,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space6.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space44,
                      height: Dimens.space44,
                      iconUrl: CustomIcon.icon_message_send,
                      iconColor: CustomColors.white,
                      iconSize: Dimens.space16,
                      boxDecorationColor: CustomColors.mainColor,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      imageUrl: "",
                      onTap: widget.onSendTap,
                    ),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        // isShowSticker = false;
      });
    }
  }
}

class PlainChatTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final Function? onSendTap;

  const PlainChatTextField(
      {Key? key, this.textEditingController, this.onSendTap})
      : super(key: key);

  @override
  _PlainChatTextFieldState createState() {
    return _PlainChatTextFieldState();
  }
}

class _PlainChatTextFieldState extends State<PlainChatTextField> {
  int maxlines = 0;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space8.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      decoration: BoxDecoration(
        color: CustomColors.baseLightColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space12.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              child: TextField(
                controller: widget.textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: maxlines == 0 ? null : maxlines,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: CustomColors.textPrimaryLightColor,
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space14.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.newline,
                inputFormatters: [
                  NoLeadingSpaceFormatter(),
                  LengthLimitingTextInputFormatter(660),
                ],
                onChanged: (value) {
                  if (value.length > 120) {
                    maxlines = 4;
                  } else {
                    maxlines = 0;
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent, width: Dimens.space0.w),
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space12.w)),
                  ),
                  filled: true,
                  fillColor: CustomColors.baseLightColor,
                  hintText: Utils.getString("typeYourMessage"),
                  hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: CustomColors.textPrimaryLightColor,
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space14.sp,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          Container(
            height: Dimens.space40.w,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space6.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: CounterWidget(
              characterCount: widget.textEditingController!.text.length,
            ),
          ),
          Container(
            width: Dimens.space40.w,
            height: Dimens.space40.w,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space8.w, Dimens.space6.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedNetworkImageHolder(
              width: Dimens.space24,
              height: Dimens.space24,
              iconUrl: CustomIcon.icon_message_send,
              iconColor: CustomColors.mainColor,
              iconSize: Dimens.space20,
              boxDecorationColor: CustomColors.transparent,
              outerCorner: Dimens.space300,
              innerCorner: Dimens.space300,
              imageUrl: "",
              onTap: widget.onSendTap!,
            ),
          ),
        ],
      ),
    );
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        // isShowSticker = false;
      });
    }
  }
}
