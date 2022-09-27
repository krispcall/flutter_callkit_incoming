// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

import "package:flutter/material.dart";
import "package:mvp/utils/Utils.dart";

class CustomColors {
  CustomColors._();

  ///
  /// Main Color
  ///
  static Color? mainColor;
  static Color? mainColorWithWhite;
  static Color? mainColorWithBlack;
  static Color? mainDarkColor;
  static Color? mainLightColor;
  static Color? mainLightColorWithBlack;
  static Color? mainLightColorWithWhite;
  static Color? mainShadowColor;
  static Color? mainLightShadowColor;
  static Color? mainDividerColor;
  static Color? mainBackgroundColor;
  static Color? mainIconColor;

  ///
  /// Base Color
  ///
  static Color? baseColor;
  static Color? baseDarkColor;
  static Color? baseLightColor;

  ///
  /// Text Color
  ///
  static Color? textPrimaryColor;
  static Color? textSecondaryColor;
  static Color? textTertiaryColor;
  static Color? textQuaternaryColor;
  static Color? textQuinaryColor;
  static Color? textSenaryColor;
  static Color? textSenaryColorSec;

  static Color? textPrimaryDarkColor;
  static Color? textPrimaryLightColor;
  static Color? textPrimaryErrorColor;
  static Color? textBoldColor;

  ///
  /// Icon Color
  ///
  static Color? iconColor;
  static Color? iconColorBlack;

  ///
  /// Background Color
  ///
  static Color? coreBackgroundColor;
  static Color? coreSecondaryColor;
  static Color? backgroundColor;
  static Color? errorBackgroundColor;
  static Color? callAcceptColor;
  static Color? callOnProgressColor;

  static Color? callDeclineColor;
  static Color? callDeclineColorLight;
  static Color? callInactiveColor;
  static Color? bottomAppBarColor;
  static Color? mainSecondaryColor;
  static Color? secondaryColor;
  static Color? warningColor;
  static Color? expiredColor;
  static Color? callDisableColor;

  ///
  /// General
  ///
  static Color? white;
  static Color? black;
  static Color? grey;
  static Color? transparent;

  ///
  /// Customs
  ///
  static Color? facebookLoginButtonColor;
  static Color? googleLoginButtonColor;
  static Color? phoneLoginButtonColor;
  static Color? appleLoginButtonColor;
  static Color? discountColor;
  static Color? disabledFacebookLoginButtonColor;
  static Color? disabledGoogleLoginButtonColor;
  static Color? disabledPhoneLoginButtonColor;
  static Color? disabledAppleLoginButtonColor;
  static Color? geryColor;

  static Color? categoryBackgroundColor;
  static Color? loadingCircleColor;
  static Color? blueLightColor;
  static Color? startButtonColor;
  static Color? ratingColor;
  static Color? progressBarColor;

  static Color? progressBarInactiveColor;

  static Color? timezoneColor;

  /// Colors Config For the whole App
  /// Please change the color based on your brand need.
  ///

  //Button Color

  static Color? redButtonColor;
  static Color? lightRedColor;
  static Color? redIconContainerColor;
  static Color? callStatusContainerColor;
  static Color? missedContainerColor;

  ///
  /// Light Theme
  ///
  static const Color _l_base_color = Color(0xFFE6E6E6);
  static const Color _l_base_seconday_color = Color(0xFFECE6F2);
  static const Color _l_base_dark_color = Color(0xFFE5E5E5);
  static const Color _l_base_light_color = Color(0xFFF5F2F8);

  static const Color _l_text_primary_color = Color(0xFF251A43);
  static const Color _l_text_secondary_color = Color(0xFF564D6D);
  static const Color _l_text_tertiary_color = Color(0xFF6E6681);
  static const Color _l_text_quaternary_color = Color(0xFF9E99AB);
  static const Color _l_text_quinary_color = Color(0xFFB7B3C1);
  static const Color _l_text_senary_color = Color(0xFF3D3358);

  static const Color _l_text_primary_light_color = Color(0xFF857F96);
  static const Color _l_text_primary_dark_color = Color(0xFF25425D);
  static const Color _l_text_error_color = Color(0xFFDB312B);

  static const Color _l_icon_color = Color(0xFF445E76);
  static const Color _l_icon_color_black = Color(0xFF333333);

  static const Color _l_divider_color = Color(0xFFE7E6EB);

  ///
  /// Dark Theme
  ///
  static const Color _d_base_color = Color(0xFF212121);
  static const Color _d_base_seconday_color = Color(0xFFECE6F2);
  static const Color _d_base_dark_color = Color(0xFFE5E5E5);
  static const Color _d_base_light_color = Color(0xFFF5F2F8);

  static const Color _d_text_primary_color = Color(0xFF251A43);
  static const Color _d_text_secondary_color = Color(0xFF564D6D);
  static const Color _d_text_tertiary_color = Color(0xFF6E6681);
  static const Color _d_text_quaternary_color = Color(0xFF9E99AB);
  static const Color _d_text_quinary_color = Color(0xFFB7B3C1);
  static const Color _d_text_senary_color = Color(0xFF3D3358);
  static const Color d_text_senary_color_sec = Color(0xFF271A4A);

  static const Color _d_text_primary_light_color = Color(0xFF857F96);
  static const Color _d_text_primary_dark_color = Color(0xFFFFFFFF);
  static const Color _d_text_error_color = Color(0xFFDB312B);
  static const Color _d_text_red_color = Color(0xFFDB312B);
  static const Color _d_text_bold_color = Color(0xFF0D002E);

  static const Color _d_icon_color = Colors.white;
  static const Color _d_icon_color_black = Color(0xFF333333);

  static const Color _d_divider_color = Color(0xFFE7E6EB);

  ///
  /// Common Theme
  ///
  static const Color _c_main_color = Color(0xFF390179);
  static const Color _c_main_light_color = Color(0xFF390179);
  static const Color _c_main_dark_color = Color(0xFF390179);
  static const Color _c_main_background_color = Color(0xFFF9F7FB);
  static const Color _c_main_icon_color = Color(0xFF445668);

  static const Color _c_white_color = Colors.white;
  static const Color _c_black_color = Colors.black;
  static const Color _c_grey_color = Colors.grey;
  static const Color _c_blue_color = Color(0xFF1A63F4);
  static const Color _c_blue_light_color = Color(0xFF4882F6);
  static const Color _c_transparent_color = Colors.transparent;

  static const Color _c_facebook_login_color = Color(0xFF2153B2);
  static const Color _c_call_accept_color = Color(0xFF4C9610);
  static const Color _c_green_color = Color(0xFF14C127);
  static const Color _c_call_decline_color = Color(0xFFDB312B);
  static const Color _c_call_decline_color_light = Color(0xFFFDF4F4);
  static const Color _c_call_inactive_color = Color(0xFFCFCCD5);
  static const Color _c_bottom_app_bar_color = Color(0xFFF3F2F4);
  static const Color _c_main_secondary_color = Color(0xFF613494);
  static const Color _c_secondary_color = Color(0xFFD7CCE4);
  static const Color _c_call_disable_color = Color(0xff522A80);
  static const Color _c_call_failed_color = Color(0xffFCEBEA);
  static const Color _c_call_failed_icon_container_color = Color(0xffF8D6D5);
  static const Color _c_call_status_container_color = Color(0xffF3F2F4);
  static const Color _c_missed_container_color = Color(0xffDB312B);

  static const Color _c_google_login_color = Color(0xFFFF4D4D);
  static const Color _c_phone_login_color = Color(0xFF9F7A2A);
  static const Color _c_apple_login_color = Color(0xFF111111);
  static const Color _c_discount_color = Color(0xFFFF4D4D);
  static const Color _c_error_background_color = Color(0xFFFCEBEA);
  static const Color _c_warning_color = Color(0xFFE07408);
  static const Color _c_expired_color = Color(0xFFE69039);
  static const Color _c_timezone_color = Color(0xFFF3F7FE);

  static const Color _c_rating_color = Color(0xFFF8E71C);

  static const Color ps_ctheme__color_about_us = Colors.cyan;
  static const Color ps_ctheme__color_application = Colors.blue;
  static const Color ps_ctheme__color_line = Color(0xFFbdbdbd);

  static const Color _ps_progress_color = Color(0xFFE2EBFC);
  static const Color _ps_incactive_progress_color =
      Color.fromRGBO(243, 247, 254, 1);

  static void loadColor(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadDarkColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    mainColorWithWhite = _c_main_color;
    mainColorWithBlack = _c_main_color;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _c_main_dark_color;
    mainLightColorWithWhite = _c_main_dark_color;
    mainShadowColor = _c_main_color.withOpacity(0.6);
    mainLightShadowColor = _c_main_light_color;
    mainDividerColor = _d_divider_color;
    secondaryColor = _c_secondary_color;
    warningColor = _c_warning_color;
    expiredColor = _c_expired_color;
    mainBackgroundColor = _c_main_background_color;
    mainIconColor = _c_main_icon_color;

    ///
    /// Base Color
    ///
    baseColor = _d_base_color;
    baseDarkColor = _d_base_dark_color;
    baseLightColor = _d_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _d_text_primary_color;
    textSecondaryColor = _d_text_secondary_color;
    textTertiaryColor = _d_text_tertiary_color;
    textQuaternaryColor = _d_text_quaternary_color;
    textQuinaryColor = _d_text_quinary_color;
    textSenaryColor = _d_text_senary_color;
    textSenaryColorSec = d_text_senary_color_sec;

    textPrimaryDarkColor = _d_text_primary_dark_color;
    textPrimaryLightColor = _d_text_primary_light_color;
    textPrimaryErrorColor = _d_text_error_color;
    textBoldColor = _d_text_bold_color;

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;
    iconColorBlack = _d_icon_color_black;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _d_base_color;
    coreSecondaryColor = _d_base_seconday_color;
    backgroundColor = _d_base_dark_color;
    errorBackgroundColor = _c_error_background_color;
    callAcceptColor = _c_call_accept_color;
    callAcceptColor = _c_call_accept_color;
    callOnProgressColor = _c_green_color;
    callDeclineColor = _c_call_decline_color;
    callDeclineColorLight = _c_call_decline_color_light;
    callInactiveColor = _c_call_inactive_color;
    bottomAppBarColor = _c_bottom_app_bar_color;
    mainSecondaryColor = _c_main_secondary_color;
    callDisableColor = _c_call_disable_color;
    lightRedColor = _c_call_failed_color;
    redIconContainerColor = _c_call_failed_icon_container_color;
    callStatusContainerColor = _c_call_status_container_color;
    missedContainerColor = _c_missed_container_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    discountColor = _c_discount_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    categoryBackgroundColor = _d_base_light_color;
    loadingCircleColor = _c_blue_color;
    blueLightColor = _c_blue_light_color;
    startButtonColor = _c_blue_color;
    ratingColor = _c_rating_color;
    redButtonColor = _d_text_red_color;
    progressBarColor = _ps_progress_color;
    progressBarInactiveColor = _ps_incactive_progress_color;
    timezoneColor = _c_timezone_color;
  }

  static void _loadLightColors() {
    ///
    /// Main Color
    ///
    mainColor = _c_main_color;
    mainColorWithWhite = _c_main_color;
    mainColorWithBlack = _c_main_color;
    mainDarkColor = _c_main_dark_color;
    mainLightColor = _c_main_light_color;
    mainLightColorWithBlack = _c_main_light_color;
    mainLightColorWithWhite = _c_main_light_color;
    mainShadowColor = _c_main_color.withOpacity(0.6);
    mainLightShadowColor = _c_main_light_color;
    mainDividerColor = _l_divider_color;
    secondaryColor = _c_secondary_color;
    warningColor = _c_warning_color;
    expiredColor = _c_expired_color;
    mainBackgroundColor = _c_main_background_color;
    mainIconColor = _c_main_icon_color;

    ///
    /// Base Color
    ///
    baseColor = _l_base_color;
    baseDarkColor = _l_base_dark_color;
    baseLightColor = _l_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _l_text_primary_color;
    textSecondaryColor = _l_text_secondary_color;
    textTertiaryColor = _l_text_tertiary_color;
    textQuaternaryColor = _l_text_quaternary_color;
    textQuinaryColor = _l_text_quinary_color;
    textSenaryColor = _l_text_senary_color;

    textPrimaryDarkColor = _l_text_primary_dark_color;
    textPrimaryLightColor = _l_text_primary_light_color;
    textPrimaryErrorColor = _l_text_error_color;
    textBoldColor = _d_text_bold_color;

    ///
    /// Icon Color
    ///
    iconColor = _l_icon_color;
    iconColorBlack = _l_icon_color_black;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _l_base_color;
    coreSecondaryColor = _l_base_seconday_color;
    backgroundColor = _l_base_dark_color;
    errorBackgroundColor = _c_error_background_color;
    callAcceptColor = _c_call_accept_color;
    callOnProgressColor = _c_green_color;
    callDeclineColor = _c_call_decline_color;
    callDeclineColorLight = _c_call_decline_color_light;
    callInactiveColor = _c_call_inactive_color;
    bottomAppBarColor = _c_bottom_app_bar_color;
    mainSecondaryColor = _c_main_secondary_color;
    lightRedColor = _c_call_failed_color;
    redIconContainerColor = _c_call_failed_icon_container_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    discountColor = _c_discount_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    geryColor = _c_grey_color;
    categoryBackgroundColor = _c_main_light_color;
    loadingCircleColor = _c_blue_color;
    startButtonColor = _c_blue_color;
    blueLightColor = _c_blue_light_color;
    ratingColor = _c_rating_color;
    redButtonColor = _d_text_red_color;
    startButtonColor = _c_blue_color;
    progressBarColor = _ps_progress_color;
    progressBarInactiveColor = _ps_incactive_progress_color;
    timezoneColor = _c_timezone_color;
  }
}
