import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:provider/provider.dart";

/*
 * *
 *  * Created by Kedar on 10/7/21 11:36 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 10/7/21 11:36 AM
 *
 */

class LastContactedWidget extends StatefulWidget {
  final String? number;

  const LastContactedWidget({Key? key, this.number}) : super(key: key);

  @override
  _LastContactedWidgetState createState() {
    return _LastContactedWidgetState();
  }
}

class _LastContactedWidgetState extends State<LastContactedWidget> {
  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;

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
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    return ChangeNotifierProvider<ContactsProvider>(
      lazy: false,
      create: (BuildContext context) {
        contactsProvider =
            ContactsProvider(contactRepository: contactRepository);
        contactsProvider!
            .doGetLastContactedApiCall(Map.from({"contact": widget.number}));
        return contactsProvider!;
      },
      child: Consumer<ContactsProvider>(
        builder:
            (BuildContext context, ContactsProvider? provider, Widget? child) {
          if (provider!.lastContactedDate!.data != null) {
            return Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : "${Utils.getString("lastContacted")} ${provider.lastContactedDate!.data}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space14.sp,
                    fontWeight: FontWeight.normal,
                    color: CustomColors.textPrimaryColor,
                    fontStyle: FontStyle.normal),
              ),
            );
          } else {
            return Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontFamily: Config.heeboRegular,
                      fontSize: Dimens.space14.sp,
                      fontWeight: FontWeight.normal,
                      color: CustomColors.textPrimaryColor,
                      fontStyle: FontStyle.normal),
                ));
          }
        },
      ),
    );
  }
}
