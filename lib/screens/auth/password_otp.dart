import 'package:zayed3ndk/custom/btn.dart';
import 'package:zayed3ndk/custom/device_info.dart';
import 'package:zayed3ndk/custom/input_decorations.dart';
import 'package:zayed3ndk/custom/lang_text.dart';
import 'package:zayed3ndk/custom/toast_component.dart';
import 'package:zayed3ndk/my_theme.dart';
import 'package:zayed3ndk/repositories/auth_repository.dart';
import 'package:zayed3ndk/screens/auth/login.dart';
import 'package:zayed3ndk/screens/auth/otp.dart';
import 'package:zayed3ndk/ui_elements/auth_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timer_count_down/timer_controller.dart';

class PasswordOtp extends StatefulWidget {
  PasswordOtp({Key? key, this.verify_by = "email", this.email_or_code})
      : super(key: key);
  final String verify_by;
  final String? email_or_code;

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  //controllers
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  CountdownController countdownController = CountdownController(autoStart: true);
  bool canResend = false;

  String headeText = "";

  FlipCardController cardController = FlipCardController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      headeText = AppLocalizations.of(context)!.enter_the_code_sent;
      setState(() {});
    });
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    countdownController.pause();
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressConfirm() async {
    var code = _codeController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.enter_the_code,
      );
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.enter_password,
      );
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.confirm_your_password,
      );
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!
            .password_must_contain_at_least_6_characters,
      );
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.passwords_do_not_match,
      );
      return;
    }

    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, password);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(
        passwordConfirmResponse.message!,
      );
    } else {
      ToastComponent.showDialog(
        passwordConfirmResponse.message!,
      );

      headeText = AppLocalizations.of(context)!.password_changed_ucf;
      cardController.toggleCard();
      setState(() {});
    }
  }

  onTapResend() async {
    setState(() {
      canResend = false;
    });
    var passwordResendCodeResponse = await AuthRepository()
        .getPasswordForgetResponse(widget.email_or_code, widget.verify_by);

    if (passwordResendCodeResponse.result == false) {
      ToastComponent.showDialog(
        passwordResendCodeResponse.message!,
      );
    } else {
      ToastComponent.showDialog(
        passwordResendCodeResponse.message!,
      );
    }
  }

  gotoLoginScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        headeText,
        WillPopScope(
            onWillPop: () {
              gotoLoginScreen();
              return Future.delayed(Duration.zero);
            },
            child: buildBody(context, _screen_width, _verify_by)));
  }

  Widget buildBody(
      BuildContext context, double _screen_width, String _verify_by) {
    return FlipCard(
      flipOnTouch: false,
      controller: cardController,
      //fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
      direction: FlipDirection.HORIZONTAL,
      // default
      front: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: _verify_by == "email"
                      ? Text(
                          AppLocalizations.of(context)!
                              .enter_the_verification_code_that_sent_to_your_email_recently,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: MyTheme.dark_grey, fontSize: 14))
                      : Text(
                          AppLocalizations.of(context)!
                              .check_your_WhatsApp_messages_to_retrieve_the_verification_code,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.dark_grey, fontSize: 14))),
            ),
            Container(
              width: _screen_width * (3 / 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)!.enter_the_code,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _codeController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "A X B 4 J H"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)!.password_ucf,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 36,
                          child: TextField(
                            controller: _passwordController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hint_text: "• • • • • • • •"),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .password_must_contain_at_least_6_characters,
                          style: TextStyle(
                              color: MyTheme.textfield_grey,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      AppLocalizations.of(context)!.retype_password_ucf,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 36,
                      child: TextField(
                        controller: _passwordConfirmController,
                        autofocus: false,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "• • • • • • • •"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyTheme.textfield_grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: Btn.basic(
                        minWidth: MediaQuery.of(context).size.width,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
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
              padding: const EdgeInsets.only(top: 50),
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
          ],
        ),
      ),
      back: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: Text(LangText(context).local.congratulations_ucf,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                  width: _screen_width * (3 / 4),
                  child: Text(
                      LangText(context)
                          .local
                          .you_have_successfully_changed_your_password,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 13,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Image.asset(
                'assets/changed_password.png',
                width: DeviceInfo(context).width! / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 45,
                child: Btn.basic(
                  minWidth: MediaQuery.of(context).size.width,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    AppLocalizations.of(context)!.back_to_Login_ucf,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    gotoLoginScreen();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
