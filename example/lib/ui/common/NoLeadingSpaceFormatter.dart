/*
 * *
 *  * Created by Kedar on 9/8/21 8:08 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 9/8/21 8:08 AM
 *
 */

import "package:flutter/services.dart";

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(" ")) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
