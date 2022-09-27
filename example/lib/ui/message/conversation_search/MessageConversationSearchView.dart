import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/messages/MessageDetailsProvider.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/DateTimeTextWidget.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/shimmer/CallLogShimmer.dart";
import "package:mvp/ui/message/message_detail/CallStateEnum.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/common/SearchInputRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart";
import "package:provider/provider.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:substring_highlight/substring_highlight.dart";

class MessageConversationSearchView extends StatefulWidget {
  final String? channelId;
  final String? channelName;
  final String? channelNumber;
  final String? contactNumber;
  final String? contactName;
  final AnimationController? animationController;

  const MessageConversationSearchView({
    Key? key,
    this.channelId,
    this.channelName,
    this.channelNumber,
    this.contactNumber,
    this.contactName,
    this.animationController,
  }) : super(key: key);

  @override
  _MessageConversationSearchViewState createState() =>
      _MessageConversationSearchViewState();
}

class _MessageConversationSearchViewState
    extends State<MessageConversationSearchView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  final TextEditingController controllerSearchQuery = TextEditingController();
  Animation<double>? animation;
  MessageDetailsProvider? messagesProvider;
  MessageDetailsRepository? messagesRepository;
  ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController();

  StreamSubscription? streamSubscriptionOnNetworkChanged;

  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;

  @override
  void initState() {
    doCheckConnection();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    super.initState();
    messagesRepository =
        Provider.of<MessageDetailsRepository>(context, listen: false);
  }

  @override
  void dispose() {
    controllerSearchQuery.dispose();
    streamSubscriptionOnNetworkChanged!.cancel();
    animationController!.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Future<void> onSubmitData(String keyword) async {
    final SearchConversationRequestHolder searchConversationRequestHolder =
        SearchConversationRequestHolder(
      channel: widget.channelId!,
      contact: widget.contactNumber!,
      param: SearchConversationRequestParamHolder(
        first: 1000000000,
        search: SearchInputRequestParamHolder(
          columns: ["sms"],
          value: keyword,
        ),
      ),
    );

    await messagesProvider!.doSearchConversationApiCall(
      searchConversationRequestHolder,
    );
  }

  Future<void> _onLoading() async {
    if (internetConnectionStatus == InternetConnectionStatus.connected) {
      if (messagesRepository!.pageInfoConversationSearch!.hasPreviousPage!) {
        Utils.cPrint("On Loading");
        final SearchConversationRequestHolder searchConversationRequestHolder =
            SearchConversationRequestHolder(
          channel: widget.channelId!,
          contact: widget.contactNumber!,
          param: SearchConversationRequestParamHolder(
            first: Config.DEFAULT_LOADING_LIMIT,
            search: SearchInputRequestParamHolder(
              columns: ["sms"],
              value: controllerSearchQuery.text,
            ),
          ),
        );

        await messagesProvider!
            .doSearchConversationApiCall(searchConversationRequestHolder);
        if (mounted) setState(() {});
        refreshController.refreshCompleted();
      } else {
        if (mounted) setState(() {});
        refreshController.refreshCompleted();
      }
    } else {
      if (mounted) setState(() {});
      refreshController.refreshCompleted();
    }
  }

  Future<void> _onRefresh() async {
    if (internetConnectionStatus == InternetConnectionStatus.connected) {
      if (messagesRepository!.pageInfoConversationSearch!.hasNextPage!) {
        Utils.cPrint("On Refresh");
        await messagesProvider!.doGetNextSearchedConversationApiCall(
          widget.channelId!,
          widget.contactNumber!,
          controllerSearchQuery.text,
        );
        if (mounted) setState(() {});
        refreshController.loadComplete();
      } else {
        if (mounted) setState(() {});
        refreshController.loadComplete();
      }
    } else {
      if (mounted) setState(() {});
      refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MessageDetailsProvider>(
      lazy: false,
      create: (BuildContext context) {
        messagesProvider = MessageDetailsProvider(
            messageDetailsRepository: messagesRepository!);
        return messagesProvider!;
      },
      child: Consumer<MessageDetailsProvider>(
        builder: (BuildContext? context, MessageDetailsProvider? provider,
            Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space16.r),
                topRight: Radius.circular(Dimens.space16.r),
              ),
              color: CustomColors.white,
            ),
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: ScreenUtil().screenWidth,
            child: Column(
              children: [
                Container(
                  height: Dimens.space50.h,
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColors.bottomAppBarColor!,
                        width: Dimens.space1.w,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context!);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          child: Icon(
                            CustomIcon.icon_arrow_left,
                            color: CustomColors.loadingCircleColor,
                            size: Dimens.space22.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
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
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("searchConversation"),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context!)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space20.h, Dimens.space16.w, Dimens.space10.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  height: Dimens.space52.h,
                  child: TextField(
                    controller: controllerSearchQuery,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space16.sp,
                          fontStyle: FontStyle.normal,
                        ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                      fillColor: CustomColors.baseLightColor,
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
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        margin: EdgeInsets.fromLTRB(Dimens.space15.w,
                            Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                        child: Icon(
                          CustomIcon.icon_search,
                          size: Dimens.space16.w,
                          color: CustomColors.textTertiaryColor,
                        ),
                      ),
                      hintText: Utils.getString("searchConversation"),
                      hintStyle:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textTertiaryColor,
                                fontFamily: Config.heeboRegular,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimens.space16.sp,
                                fontStyle: FontStyle.normal,
                              ),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (submittedQuery) async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Utils.checkInternetConnectivity().then((data) async {
                        if (data) {
                          onSubmitData(submittedQuery);
                        } else {
                          Utils.showWarningToastMessage(
                              Utils.getString("noInternet"), context);
                        }
                      });
                    },
                  ),
                ),
                messagesProvider!.listSearchConversation?.status !=
                        Status.NO_ACTION
                    ? Expanded(
                        child: messagesProvider!
                                    .listSearchConversation?.status !=
                                Status.PROGRESS_LOADING
                            ? Container(
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
                                child: messagesProvider!.listSearchConversation
                                                ?.status !=
                                            Status.ERROR &&
                                        messagesProvider!
                                                .listSearchConversation !=
                                            null &&
                                        messagesProvider!
                                                .listSearchConversation?.data !=
                                            null &&
                                        messagesProvider!
                                            .listSearchConversation!
                                            .data!
                                            .isNotEmpty
                                    ? SmartRefresher(
                                        enablePullUp: true,
                                        header: CustomHeader(
                                          builder: (BuildContext? context,
                                              RefreshStatus? mode) {
                                            Widget body;
                                            if (mode == RefreshStatus.idle) {
                                              body = Container();
                                            } else if (mode ==
                                                RefreshStatus.refreshing) {
                                              body = Container(
                                                alignment: Alignment.topCenter,
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      CustomColors.white,
                                                  color: CustomColors.mainColor,
                                                ),
                                              );
                                            } else if (mode ==
                                                RefreshStatus.failed) {
                                              body = Container();
                                            } else if (mode ==
                                                RefreshStatus.canRefresh) {
                                              body = Container();
                                            } else {
                                              body = Container();
                                            }
                                            return body;
                                          },
                                        ),
                                        footer: CustomFooter(
                                          height: Dimens.space5.h,
                                          builder: (BuildContext? context,
                                              LoadStatus? mode) {
                                            Widget body;
                                            if (mode == LoadStatus.idle) {
                                              body = Container();
                                            } else if (mode ==
                                                LoadStatus.loading) {
                                              body = Container(
                                                alignment: Alignment.center,
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      CustomColors.white,
                                                  color: CustomColors.mainColor,
                                                ),
                                              );
                                            } else if (mode ==
                                                LoadStatus.failed) {
                                              body = Container();
                                            } else if (mode ==
                                                LoadStatus.canLoading) {
                                              body = Container();
                                            } else {
                                              body = Container();
                                            }
                                            return body;
                                          },
                                        ),
                                        controller: refreshController,
                                        onRefresh: _onLoading,
                                        onLoading: _onRefresh,
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: messagesProvider!
                                              .listSearchConversation
                                              ?.data!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Container(
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
                                              width: ScreenUtil().screenWidth,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: CustomColors
                                                        .mainDividerColor!,
                                                    width: Dimens.space1.h,
                                                  ),
                                                ),
                                              ),
                                              child: ConversationSearchWidget(
                                                searchText:
                                                    controllerSearchQuery.text,
                                                name: messagesProvider!.listSearchConversation != null &&
                                                        (messagesProvider!
                                                                .listSearchConversation
                                                                ?.data!) !=
                                                            null &&
                                                        messagesProvider!.listSearchConversation?.data![index] !=
                                                            null &&
                                                        messagesProvider!
                                                                .listSearchConversation
                                                                ?.data![index]
                                                                .recentConversationNodes !=
                                                            null &&
                                                        messagesProvider!
                                                                .listSearchConversation
                                                                ?.data![index]
                                                                .recentConversationNodes
                                                                ?.direction
                                                                ?.toLowerCase() ==
                                                            CallStateIndex.Incoming.value
                                                                .toLowerCase()
                                                    ? (widget.contactName!
                                                            .isNotEmpty)
                                                        ? widget.contactName!
                                                        : widget.contactNumber!
                                                    : messagesProvider!
                                                                .listSearchConversation
                                                                ?.data![index]
                                                                .recentConversationNodes
                                                                ?.direction
                                                                ?.toLowerCase() ==
                                                            CallStateIndex
                                                                .Outgoing.value
                                                                .toLowerCase()
                                                        ? widget.channelName!
                                                        : widget.channelNumber!,
                                                clientNumber:
                                                    widget.contactNumber!,
                                                keyword: messagesProvider!
                                                        .listSearchConversation
                                                        ?.data![index]
                                                        .recentConversationNodes
                                                        ?.content
                                                        ?.body ??
                                                    "",
                                                imageUrl: messagesProvider!
                                                        .listSearchConversation
                                                        ?.data![index]
                                                        .recentConversationNodes
                                                        ?.clientInfo
                                                        ?.profilePicture ??
                                                    "",
                                                onPressed: () {
                                                  Navigator.of(context).pop({
                                                    "data": true,
                                                    "cursor": messagesProvider!
                                                        .listSearchConversation
                                                        ?.data![index]
                                                        .cursor,
                                                    "list": messagesProvider!
                                                        .listSearchConversation
                                                        ?.data,
                                                    "query":
                                                        controllerSearchQuery
                                                            .text,
                                                  });
                                                },
                                                date: messagesProvider!
                                                        .listSearchConversation
                                                        ?.data![index]
                                                        .recentConversationNodes
                                                        ?.createdAt ??
                                                    "",
                                                timestamp: "",
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: noSearchResult(context),
                                      ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 15,
                                      itemBuilder: (context, index) {
                                        return const CallLogShimmer();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      )
                    : Expanded(
                        child: Center(
                          child: Container(
                            color: Colors.white,
                            height: Utils.getScreenHeight(context),
                            width: Utils.getScreenWidth(context),
                            child: Container(
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
                              alignment: Alignment.center,
                              child: EmptyViewUiWidget(
                                assetUrl: "assets/images/no_conversation.png",
                                title: Utils.getString("searchConversation"),
                                desc: Utils.getString(""),
                                buttonTitle:
                                    Utils.getString("startConversation"),
                                icon: Icons.add_circle_outline,
                                showButton: false,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  void doCheckConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      if (onValue) {
        internetConnectionStatus = InternetConnectionStatus.connected;
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
      }
      setState(() {});
    });

    streamSubscriptionOnNetworkChanged = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      if (status != InternetConnectionStatus.disconnected &&
          internetConnectionStatus == InternetConnectionStatus.disconnected) {
        internetConnectionStatus = InternetConnectionStatus.connected;
        setState(() {});
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        setState(() {});
      }
    });
  }
}

class ConversationSearchWidget extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final Function? onPressed;
  final String? date;
  final String? timestamp;
  final String? keyword;
  final String clientNumber;
  final String? searchText;

  const ConversationSearchWidget(
      {Key? key,
      required this.clientNumber,
      this.name,
      this.imageUrl,
      this.onPressed,
      this.date,
      this.timestamp,
      this.keyword,
      this.searchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: CustomColors.white,
          padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h,
              Dimens.space20.w, Dimens.space10.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Dimens.space48.w,
              height: Dimens.space48.w,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: RoundedNetworkImageHolder(
                width: Dimens.space48,
                height: Dimens.space48,
                containerAlignment: Alignment.bottomCenter,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space40,
                boxDecorationColor: CustomColors.mainDividerColor,
                imageUrl: imageUrl!,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text(
                              Config.checkOverFlow ? Const.OVERFLOW : name!,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space6.w,
                              Dimens.space0.h,
                              Dimens.space6.w,
                              Dimens.space0.h),
                          child: FutureBuilder<String>(
                            future: Utils.getFlagUrl(clientNumber),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RoundedNetworkImageHolder(
                                  width: Dimens.space14,
                                  height: Dimens.space14,
                                  boxFit: BoxFit.contain,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconUrl: CustomIcon.icon_gallery,
                                  iconColor: CustomColors.grey,
                                  iconSize: Dimens.space14,
                                  boxDecorationColor:
                                      CustomColors.mainBackgroundColor,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: PSApp.config!.countryLogoUrl! +
                                      snapshot.data!,
                                );
                              }
                              return const CupertinoActivityIndicator();
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.zero,
                        child: SubstringHighlight(
                          text: keyword!,
                          // each string needing highlighting
                          term: searchText,
                          // user typed "m4a"
                          overflow: TextOverflow.ellipsis,
                          textStyleHighlight: TextStyle(
                            // highlight style
                            color: CustomColors.textPrimaryColor,
                            decoration: TextDecoration.none,
                          ),
                          textStyle:
                              Theme.of(context).textTheme.button!.copyWith(
                                    color: CustomColors.textPrimaryLightColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      //   child: Offstage(
                      //     offstage: callLog.recentConversationNodes.contactPinned!=null && callLog.recentConversationNodes.contactPinned?false:true,
                      //     child: RoundedNetworkImageHolder(
                      //       width: Dimens.space18,
                      //       height: Dimens.space18,
                      //       boxFit: BoxFit.cover,
                      //       iconUrl: CustomIcon.icon_pin,
                      //       iconColor: CustomColors.warningColor,
                      //       iconSize: Dimens.space12,
                      //       outerCorner: Dimens.space0,
                      //       innerCorner: Dimens.space0,
                      //       boxDecorationColor:
                      //       CustomColors.transparent,
                      //       imageUrl: "",
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: DateTimeTextWidget(
                          timestamp: timestamp!,
                          date: date!,
                          format: DateFormat("yyyy-MM-ddThh:mm:ss.SSSSSS"),
                          dateFontColor: CustomColors.textQuinaryColor!,
                          dateFontFamily: Config.manropeSemiBold,
                          dateFontSize: Dimens.space13,
                        ),
                      ),
                    ],
                  ),
                  Container(height: Dimens.space15.h),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          onPressed!();
        },
      ),
    );
  }
}
