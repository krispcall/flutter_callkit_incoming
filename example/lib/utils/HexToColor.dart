import "package:flutter/cupertino.dart";

class HexToColor extends Color {
  static int _getColorFromHex(String hexColor) {
    String colorHex = "";
    colorHex = hexColor.toUpperCase().replaceAll("#", "");
    if (colorHex.length == 6) {
      colorHex = "FF$colorHex";
    }
    return int.parse(colorHex, radix: 16);
  }

  HexToColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
