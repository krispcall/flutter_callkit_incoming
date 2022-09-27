import "package:azlistview/azlistview.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:lpinyin/lpinyin.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/shimmer/ContactShimmer.dart";
import "package:mvp/ui/contacts/contact_view/ContactListItemView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";

class ContactListDialog extends StatefulWidget {
  const ContactListDialog({
    Key? key,
    required this.onItemTap,
    required this.contacts,
    required this.animationController,
  }) : super(key: key);

  final Function(Contacts) onItemTap;
  final List<Contacts> contacts;
  final AnimationController animationController;
  @override
  ContactListDialogState createState() => ContactListDialogState();
}

class ContactListDialogState extends State<ContactListDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height.h,
      width: MediaQuery.of(context).size.width.w,
      color: CustomColors.transparent,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Scaffold(
        backgroundColor: CustomColors.transparent,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space14.h,
                  Dimens.space20.w, Dimens.space14.h),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h,
                    Dimens.space20.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("contacts"),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeBold,
                      fontWeight: FontWeight.normal,
                      fontSize: Dimens.space18.sp,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1.h,
              thickness: Dimens.space1.h,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (widget.contacts != null) {
                    if (widget.contacts.isNotEmpty) {
                      for (int i = 0; i < widget.contacts.length; i++) {
                        final String pinyin = PinyinHelper.getPinyinE(
                          widget.contacts[i].name != null &&
                                  widget.contacts[i].name!.isNotEmpty
                              ? widget.contacts[i].name!
                              : widget.contacts[i].number!,
                        );
                        final String tag = pinyin.substring(0, 1).toUpperCase();
                        widget.contacts[i].namePinyin = pinyin;
                        if (RegExp("[A-Z]").hasMatch(tag)) {
                          widget.contacts[i].tagIndex = tag;
                        } else {
                          widget.contacts[i].tagIndex = "#";
                        }
                      }
                      // A-Z sort.
                      SuspensionUtil.sortListBySuspensionTag(
                        widget.contacts,
                      );

                      // show sus tag.
                      SuspensionUtil.setShowSuspensionStatus(
                        widget.contacts,
                      );
                    }
                    return Container(
                      color: CustomColors.white,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space0.w,
                        Dimens.space0.h,
                      ),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              alignment: Alignment.topCenter,
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
                              child: widget.contacts.isNotEmpty
                                  ? AzListView(
                                      data: widget.contacts,
                                      itemCount: widget.contacts.length,
                                      susItemBuilder: (context, i) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width
                                              .sw,
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          decoration: BoxDecoration(
                                            color:
                                                CustomColors.bottomAppBarColor,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width
                                                .sw,
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space20.w,
                                                Dimens.space5.h,
                                                Dimens.space20.w,
                                                Dimens.space5.h),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              Config.checkOverFlow
                                                  ? Const.OVERFLOW
                                                  : widget.contacts[i]
                                                      .getSuspensionTag(),
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontFamily: Config.manropeBold,
                                                fontSize: Dimens.space14.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final int count =
                                            widget.contacts.length;
                                        return ContactListItemView(
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          offStage: true,
                                          contactEdges: widget.contacts[index],
                                          onTap: () async {
                                            widget.onItemTap(
                                                widget.contacts[index]);
                                          },
                                        );
                                      },
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      indexBarData:
                                          SuspensionUtil.getTagIndexList(null),
                                      indexBarMargin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      indexBarOptions: const IndexBarOptions(
                                        needRebuild: true,
                                        indexHintAlignment:
                                            Alignment.centerRight,
                                      ),
                                    )
                                  : widget.contacts.isEmpty
                                      ? Container(
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
                                          child: const SingleChildScrollView(
                                            child: Center(
                                              child:
                                                  NoSearchResultsFoundWidget(),
                                            ),
                                          ),
                                        )
                                      : Container(
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
                                          child: SingleChildScrollView(
                                            child: EmptyViewUiWidget(
                                              assetUrl:
                                                  "assets/images/empty_contact.png",
                                              title:
                                                  Utils.getString("noContacts"),
                                              desc: Utils.getString(
                                                  "noContactsDescription"),
                                              buttonTitle: Utils.getString(
                                                  "addANewContact"),
                                              icon: Icons.add_circle_outline,
                                              showButton: false,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        const ContactSearchShimmer(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 15,
                            itemBuilder: (context, index) {
                              return index == 0 || index == 5
                                  ? const ContactBarShimmer()
                                  : const ContactShimmer();
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
