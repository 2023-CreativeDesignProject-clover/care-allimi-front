import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer buffer = StringBuffer();
    String value = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    //최대 입력 가능한 글자 개수
    if (value.length > 11) {
      value = value.substring(0, 11);
    }

    if (value.startsWith("02")) { //02로 시작할 경우
      for (int i = 0; i < value.length; i++) {
        if (i == 2 || i == 6) buffer.write('-');
        buffer.write(value[i]);
      }
    } else {
      if (value.length > 10) { //000-0000-0000
        for (int i = 0; i < value.length; i++) {
          if (i == 3 || i == 7) buffer.write('-');
          buffer.write(value[i]);
        }
      } else { //000-000-0000
        for (int i = 0; i < value.length; i++) {
          if (i == 3 || i == 6) buffer.write('-');
          buffer.write(value[i]);
        }
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}