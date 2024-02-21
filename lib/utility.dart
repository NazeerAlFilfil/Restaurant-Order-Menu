import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

// TODO: Hope this is actually works as intended, pls
Color? optionColor(int index, int level) {
  if (index < level || level == 0) {
    if (level < defaultLevelColors.length) {
      return defaultLevelColors[level];
    } else {
      return Colors.transparent;
    }
  } else {
    return Colors.transparent;
  }
}

String formatNumber(double value) {
  // Format the number with two decimal places
  NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  String formattedValue = formatter.format(value);

  // Check if the number has a decimal point but ends with "0" or "00"
  if (formattedValue.contains('.') && (formattedValue.endsWith('0') || formattedValue.endsWith('00'))) {
    // Remove trailing zeros and decimal point if it's not necessary
    //formattedValue = formattedValue.replaceAll(RegExp(r"([.][0-9]*?)0+$"), "");
    formattedValue = formattedValue.replaceAll(RegExp(r"([.]*?)0+$"), "");
    formattedValue = formattedValue.replaceAll(RegExp(r"[.]$"), "");
  }

  return formattedValue;
}