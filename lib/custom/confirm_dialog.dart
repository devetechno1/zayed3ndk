import 'package:zayed3ndk/custom/AIZTypeDef.dart';
import 'package:zayed3ndk/custom/btn.dart';
import 'package:zayed3ndk/custom/device_info.dart';
import 'package:zayed3ndk/custom/lang_text.dart';
import 'package:zayed3ndk/my_theme.dart';
import 'package:flutter/material.dart';

class ConfirmDialog {
  static show(BuildContext context,
      {String? title,
      required String message,
      String? yesText,
      String? noText,
      required OnPress pressYes}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LangText(context).local.pleaseEnsureUs),
          content: Row(
            children: [
              SizedBox(
                width: DeviceInfo(context).width! * 0.6,
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14, color: MyTheme.font_grey),
                ),
              )
            ],
          ),
          actions: [
            Btn.basic(
              color: MyTheme.font_grey,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                noText ?? "",
                style: TextStyle(fontSize: 14, color: MyTheme.white),
              ),
            ),
            Btn.basic(
              color: MyTheme.golden,
              onPressed: () {
                Navigator.pop(context);
                pressYes();
              },
              child: Text(
                LangText(context).local.yes_ucf,
                style: TextStyle(fontSize: 14, color: MyTheme.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
