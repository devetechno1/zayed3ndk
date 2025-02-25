import 'package:zayed3ndk/custom/btn.dart';
import 'package:zayed3ndk/custom/input_decorations.dart';
import 'package:zayed3ndk/custom/toast_component.dart';
import 'package:zayed3ndk/helpers/auth_helper.dart';
import 'package:zayed3ndk/helpers/num_ex.dart';
import 'package:zayed3ndk/helpers/shared_value_helper.dart';
import 'package:zayed3ndk/helpers/system_config.dart';
import 'package:zayed3ndk/my_theme.dart';
import 'package:zayed3ndk/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../main.dart';

class Otp extends StatefulWidget {
  final String? title;
  final bool fromRegistration;
  const Otp({Key? key, this.title, required this.fromRegistration}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();
  CountdownController countdownController = CountdownController(autoStart: true);
  bool canResend = false;
  @override
  void initState() {
    //on Splash Screen hide statusbar
    if(!widget.fromRegistration) AuthRepository().getResendCodeResponse();
    
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    countdownController.pause();
    _verificationCodeController.dispose();
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onTapResend() async {
    setState(() {
      canResend = false;
    });
    var resendCodeResponse = await AuthRepository().getResendCodeResponse();

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(
        resendCodeResponse.message!,
      );
    } else {
      ToastComponent.showDialog(
        resendCodeResponse.message!,
      );
    }
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.enter_verification_code,
      );
      return;
    }

    var confirmCodeResponse =
        await AuthRepository().getConfirmCodeResponse(code);

    if (!(confirmCodeResponse.result)) {
      ToastComponent.showDialog(
        confirmCodeResponse.message,
      );
    } else {
      if (SystemConfig.systemUser != null) {
        SystemConfig.systemUser!.emailVerified = true;
      }
      if(widget.fromRegistration){
        context.go("/");
      }else{
        context.pop();
      }
      ToastComponent.showDialog(confirmCodeResponse.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _screen_width = MediaQuery.sizeOf(context).width;
    final double _screen_height = MediaQuery.sizeOf(context).height;
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              color: MyTheme.soft_accent_color,
              width: _screen_width,
              height: 200,
              child: Image.asset(
                  "assets/splash_login_registration_background_image.png"),
            ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title!,
                      style: TextStyle(fontSize: 25, color: MyTheme.font_grey),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: Image.asset(
                          'assets/login_registration_form_logo.png'),
                    ),
                  ),
                  Container(
                    width: _screen_width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _verificationCodeController,
                                  autofocus: false,
                                  textAlign: TextAlign.center,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "A X B 4 J H"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _screen_height * 0.2),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Btn.basic(
                              minWidth: MediaQuery.of(context).size.width,
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context)!.confirm_ucf,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressConfirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(AppLocalizations.of(context)!.check_your_WhatsApp_messages_to_retrieve_the_verification_code,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 13)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: InkWell(
                      onTap: canResend ? onTapResend : null,
                      child: Text(AppLocalizations.of(context)!.resend_code_ucf,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: canResend? MyTheme.accent_color : Theme.of(context).disabledColor,
                              decoration: TextDecoration.underline,
                              fontSize: 13)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 60),
                    child: Visibility(
                      visible: !canResend,
                      child: TimerWidget(
                        duration: Duration(seconds: 20), 
                        callback: () {
                            setState(() {
                              countdownController.restart();
                              canResend = true;
                            });
                        }, 
                        controller: countdownController,
                      ),
                    ),
                  ),
                  // SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          onTapLogout(context);
                        },
                        child: Text(AppLocalizations.of(context)!.logout_ucf,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  onTapLogout(context) {
    try {
      AuthHelper().clearUserData(); // Ensure this clears user data properly
      routes.push("/");
    } catch (e) {
      print('Error navigating to Main: $e');
    }
  }
}


class TimerWidget extends StatelessWidget {
  const TimerWidget({
    required this.duration,
    required this.callback,
    required this.controller,
  });
  final CountdownController? controller;

  final Duration duration;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6, bottom: 2, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Countdown(
        controller: controller,
        seconds: duration.inSeconds,
        onFinished: callback,
        build: (BuildContext context, double seconds) => Text(seconds.fromSeconds ?? ''),
      ),
    );
  }
}
