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
  if (formattedValue.contains('.') &&
      (formattedValue.endsWith('0') || formattedValue.endsWith('00'))) {
    // Remove trailing zeros and decimal point if it's not necessary
    //formattedValue = formattedValue.replaceAll(RegExp(r"([.][0-9]*?)0+$"), "");
    formattedValue = formattedValue.replaceAll(RegExp(r"([.]*?)0+$"), "");
    formattedValue = formattedValue.replaceAll(RegExp(r"[.]$"), "");
  }

  return formattedValue;
}

String formatDate({required DateTime date, TimeOfDay? time}) {
  time ??= TimeOfDay.fromDateTime(date);

  String formattedDate = 'On ${date.month}/${date.day} At [';

  if (time.hour % 12 == 0) {
    formattedDate += '12';
  } else {
    formattedDate += '${time.hour % 12}';
  }
  formattedDate += ':';
  if (time.minute < 10) {
    formattedDate += '0${time.minute}';
  } else {
    formattedDate += '${time.minute}';
  }
  if (time.hour > 12) {
    formattedDate += ' PM';
  } else {
    formattedDate += ' AM';
  }

  formattedDate += ']';

  // All in one line
  // String formattedDate = 'On ${date.month}/${date.day} At [${time.hour == 0 ? (time.hour + 12) : (time.hour == 12 ? time.hour : time.hour % 12) }:${time.minute < 10 ? '0${time.minute}' : time.minute} ${time.hour >= 12 ? 'PM' : 'AM'}]';

  return formattedDate;
}
