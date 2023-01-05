import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/Common/text_widget.dart';
import 'package:soan/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soan/controllers/auth_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:provider/provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/signin_view.dart';
import 'package:soan/ui/provider/p_landing_view.dart';
import 'package:soan/ui/customer/landing_view.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key, required this.from, required this.number})
      : super(key: key);
  final String from;
  final String number;

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  CountdownTimerController controller = CountdownTimerController(endTime: 0);
  bool isLoading = false;
  bool canResend = false;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    canResend = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 132.h,
              ),
              TextWidget(
                  text: LocaleKeys.titles_phone_verification.tr(),
                  size: 26,
                  color: kDarkBleuColor,
                  fontWeight: FontWeight.normal),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 275.w,
                child: Text(
                  textAlign: TextAlign.center,
                  " ${LocaleKeys.auth_code_was_sent.tr()} ${widget.number}",
                  style: GoogleFonts.tajawal(
                    fontSize: 18.sp,
                    color: kLightDarkBleuColor,
                  ),
                ),
              ),
              SizedBox(
                height: 73.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    showCursor: true,
                    cursorColor: kDarkBleuColor,
                    textStyle: GoogleFonts.tajawal(color: kDarkBleuColor),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      fieldHeight: 60.h,
                      fieldWidth: 60.w,
                      errorBorderColor: Colors.red,
                      activeFillColor: kLightLightGreyColor,
                      inactiveFillColor: kLightLightGreyColor,
                      inactiveColor: kLightLightGreyColor,
                      activeColor: kLightLightGreyColor,
                      selectedFillColor: kLightLightGreyColor,
                      disabledColor: kLightLightGreyColor,
                      selectedColor: kLightLightGreyColor,
                    ),
                    enabled: true,
                    animationDuration: const Duration(milliseconds: 300),
                    onCompleted: (v) async {
                      setState(() {
                        isLoading = true;
                      });
                      if (widget.from == "provider") {
                        await AuthController.checkOtpProvider(
                                phone: widget.number, otp: v)
                            .then((value) async {
                          setState(() {
                            isLoading = false;
                          });
                          if (value.runtimeType == ProviderModel) {
                            final ProviderModel p = value;
                            if (p.approved == "false") {
                              await AuthController.logout(
                                token: p.apiToken,
                              ).then((value) {
                                if (value == 'تم تسجيل الخروج') {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInView()),
                                      (Route<dynamic> route) => false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        LocaleKeys.auth_subscribed_under_review
                                            .tr(),
                                      ),
                                    ),
                                  );
                                }
                              });
                            } else {
                              Provider.of<ProviderProvider>(context,
                                      listen: false)
                                  .setProvider(value);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PlandingView()),
                                  (Route<dynamic> route) => false);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kBlueColor,
                                content: Text(
                                  value.toString(),
                                ),
                              ),
                            );
                          }
                        });
                      }
                      if (widget.from == "costumer") {
                        await AuthController.checkOtp(
                                phone: widget.number, otp: v)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value.runtimeType == UserModel) {
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(value);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LandingView()),
                                (Route<dynamic> route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kBlueColor,
                                content: Text(
                                  value.toString(),
                                ),
                              ),
                            );
                          }
                        });
                      }
                    },
                    onChanged: (value) {},
                    appContext: context,
                  ),
                ),
              ),
              SizedBox(
                height: 31.h,
              ),
              GestureDetector(
                onTap: () async {
                  if (canResend) {
                    setState(() {
                      isLoading = true;
                    });
                    log(widget.number);
                    await AuthController.reSendOtp(widget.number).then((value) {
                      isLoading = false;
                      canResend = false;
                      final int endT =
                          DateTime.now().millisecondsSinceEpoch + 1000 * 30;

                      controller = CountdownTimerController(
                        endTime: endT,
                        onEnd: onEnd,
                      );
                      setState(() {});
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: LocaleKeys.auth_resend_code.tr(),
                      size: 18,
                      color: canResend ? kGreenColor : kLightLightSkyBlueColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CountdownTimer(
                      controller: controller,
                      onEnd: onEnd,
                      endTime: endTime,
                      endWidget: const Text(""),
                      widgetBuilder: (context, time) {
                        return TextWidget(
                          text: time == null ? "" : time.sec.toString(),
                          size: 18,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
