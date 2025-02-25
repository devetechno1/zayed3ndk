import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one_context/one_context.dart';

import '../my_theme.dart';

class ToastComponent {
  static showDialog(String msg, {bool isError =false ,Toast? toastLength, ToastGravity? gravity, Color? color}) {
    // ToastContext().init(OneContext().context!);
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      // toastLength: duration != 0 ? duration : Toast.LENGTH_LONG,
      // gravity: gravity != 0 ? gravity : ToastGravity.BOTTOM,
      toastLength: toastLength ?? Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.CENTER,
      backgroundColor: isError? Theme.of(OneContext().context!).colorScheme.error : color ?? Color.fromRGBO(239, 239, 239, .9),
      textColor: color != null  || isError? MyTheme.white : MyTheme.font_grey,
      // border: Border(
      //     top: BorderSide(
      //       color: Color.fromRGBO(203, 209, 209, 1),
      //     ),
      //     bottom: BorderSide(
      //       color: Color.fromRGBO(203, 209, 209, 1),
      //     ),
      //     right: BorderSide(
      //       color: Color.fromRGBO(203, 209, 209, 1),
      //     ),
      //     left: BorderSide(
      //       color: Color.fromRGBO(203, 209, 209, 1),
      //     )),
      // backgroundRadius: 6,
    );
  }
}
