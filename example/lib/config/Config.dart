import "package:mvp/utils/ColorHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/Language.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDnd.dart";
import "package:mvp/viewObject/model/dnd/UserDnd.dart";

class Config {
  Config._();

  // App Version
  static const String appVersion = "1.0.29";

  // Animation Duration
  static const Duration animation_duration = Duration(milliseconds: 100);

  // Font Family
  static const String heeboRegular = "HeeboRegular";
  static const String heeboMedium = "HeeboMedium";
  static const String heeboBlack = "HeeboBlack";
  static const String heeboBold = "HeeboBold";
  static const String heeboExtraBold = "HeeboExtraBold";
  static const String heeboLight = "HeeboLight";
  static const String heeboThin = "HeeboThin";
  static const String manropeRegular = "ManropeRegular";
  static const String manropeMedium = "ManropeMedium";
  static const String manropeBold = "ManropeBold";
  static const String manropeExtraBold = "ManropeExtraBold";
  static const String manropeLight = "ManropeLight";
  static const String manropeSemiBold = "ManropeSemiBold";
  static const String manropeThin = "ManropeThin";
  static const bool checkOverFlow = false;

  static const String app_db_name = "krispcallMVP.db";

  static final Language defaultLanguage =
      Language(languageCode: "en", countryCode: "US", name: "English US");

  static final Map<String, Language> psSupportedLanguageMap = {
    "en": Language(languageCode: "en", countryCode: "US", name: "English US"),
    "fr": Language(languageCode: "fr", countryCode: "FR", name: "French"),
    "de": Language(languageCode: "de", countryCode: "DE", name: "German"),
    "da": Language(languageCode: "da", countryCode: "DK", name: "Danish"),
    "es": Language(languageCode: "es", countryCode: "ES", name: "Spanish"),
  };

  static final Map<String, String> psSupportedEmergencyNumberMap = {
    "119": "119",
    "112": "112",
    "129": "129",
    "127": "127",
    "128": "128",
    "1548": "1548",
    "14": "14",
    "911": "911",
    "110": "110",
    "116": "116",
    "118": "118",
    "113": "113",
    "115": "115",
    "000": "000",
    "122": "122",
    "102": "102",
    "103": "103",
    "101": "101",
    "919": "919",
    "999": "999",
    "117": "117",
    "124": "124",
    "123": "123",
    "997": "997",
    "998": "998",
    "190": "190",
    "192": "192",
    "193": "193",
    "993": "993",
    "991": "991",
    "995": "995",
    "160": "160",
    "17": "17",
    "18": "18",
    "132": "132",
    "130": "130",
    "131": "131",
    "1220": "1220",
    "2251-4242": "2251-4242",
    "133": "133",
    "120": "120",
    "772-03-73": "772-03-73",
    "996": "996",
    "194": "194",
    "106": "106",
    "104": "104",
    "105": "105",
    "912": "912",
    "158": "158",
    "155": "155",
    "150": "150",
    "19": "19",
    "180": "180",
    "913": "913",
    "114": "114",
    "977": "977",
    "933": "933",
    "15": "15",
    "1730": "1730",
    "1300": "1300",
    "191": "191",
    "100": "100",
    "166": "166",
    "199": "199",
    "442-020": "442-020",
    "195": "195",
    "198": "198",
    "107": "107",
    "125": "125",
    "170": "170",
    "185": "185",
    "140": "140",
    "175": "175",
    "121": "121",
    "1515": "1515",
    "994": "994",
    "10 111": "10 111",
    "111": "111",
    "9999": "9999",
    "1122": "1122",
    "16": "16",
    "151": "151",
    "888": "888",
    "555": "555",
    "10 177": "10 177",
    "777": "777",
    "1669": "1669",
    "8200": "8200",
    "811": "811",
    "990": "990",
    "197": "197",
    "171": "171",
    "992": "992"
  };

  static final Map<int, UserDnd> timeList = {
    30: UserDnd(time: 30, title: Utils.getString("mute30mins"), status: false),
    60: UserDnd(time: 60, title: Utils.getString("mute1hour"), status: false),
    8 * 60: UserDnd(
        time: 8 * 60, title: Utils.getString("mute8hour"), status: false),
    24 * 60: UserDnd(
        time: 24 * 60, title: Utils.getString("mute24hour"), status: false),
    0: UserDnd(
        time: 0, title: Utils.getString("muteUntillBack"), status: false),
  };

  static final Map<int, ChannelDnd> channelDndTimeList = {
    -1: ChannelDnd(time: -1, title: Utils.getString("off"), status: false),
    30: ChannelDnd(
        time: 30, title: Utils.getString("mute30mins"), status: false),
    60: ChannelDnd(
        time: 60, title: Utils.getString("mute1hour"), status: false),
    8 * 60: ChannelDnd(
        time: 8 * 60, title: Utils.getString("mute8hour"), status: false),
    12 * 60: ChannelDnd(
        time: 12 * 60, title: Utils.getString("mute12hour"), status: false),
    0: ChannelDnd(
        time: 0, title: Utils.getString("muteUntillBack"), status: false),
  };

  static final List<ColorHolder> supportColorHolder = <ColorHolder>[
    ColorHolder(
      id: "1",
      colorTitle: "Green",
      colorCode: "#CCE7E1",
      backgroundColorCode: "#CCE7E1",
      isChecked: false,
    ),
    ColorHolder(
      id: "2",
      colorTitle: "Blue",
      colorCode: "#CCE4F9",
      backgroundColorCode: "#CCE4F9",
      isChecked: false,
    ),
    ColorHolder(
      id: "3",
      colorTitle: "Yellow",
      colorCode: "#FBEECC",
      backgroundColorCode: "#FBEECC",
      isChecked: false,
    ),
    ColorHolder(
      id: "4",
      colorTitle: "Mustard",
      colorCode: "#FDDFCC",
      backgroundColorCode: "#FDDFCC",
      isChecked: false,
    ),
    ColorHolder(
      id: "5",
      colorTitle: "Red",
      colorCode: "#F2BFC4",
      backgroundColorCode: "#F2BFC4",
      isChecked: false,
    ),
    ColorHolder(
      id: "6",
      colorTitle: "Gray",
      colorCode: "#E7E6EB",
      backgroundColorCode: "#E7E6EB",
      isChecked: false,
    ),
    ColorHolder(
      id: "7",
      colorTitle: "Purple",
      colorCode: "#E1D3F8",
      backgroundColorCode: "#E1D3F8",
      isChecked: false,
    ),
    ColorHolder(
      id: "8",
      colorTitle: "Pink",
      colorCode: "#F8CCE6",
      backgroundColorCode: "#F8CCE6",
      isChecked: false,
    ),
    ColorHolder(
      id: "9",
      colorTitle: "Brown",
      colorCode: "#E8D5CC",
      backgroundColorCode: "#E8D5CC",
      isChecked: false,
    ),
    ColorHolder(
      id: "10",
      colorTitle: "Orange",
      colorCode: "#FDDFCC",
      backgroundColorCode: "#FDDFCC",
      isChecked: false,
    ),
    ColorHolder(
      id: "11",
      colorTitle: "Gray100",
      colorCode: "#E7E6EB",
      backgroundColorCode: "#E7E6EB",
      isChecked: false,
    ),
    ColorHolder(
      id: "12",
      colorTitle: "Gray50",
      colorCode: "#F3F2F4",
      backgroundColorCode: "#F3F2F4",
      isChecked: false,
    ),
  ];

  // iOS App No
  static const String iOSAppStoreId = "1597876448";

  /// Default Limit
  static const int DEFAULT_LOADING_LIMIT = 20;

  static const String dateFormat = "yyyy-MM-dd";
  static const String dateFullMonthYearAndTimeFormat = "MMMM dd, y";

  static bool isFirstTime = true;
}
