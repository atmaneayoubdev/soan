import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soan/Common/large_button.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/auth_controller.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPassVisible = false;
  bool isPassConfVisible = false;
  String finalPhone = '';

  bool isCodeSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                height: 120.h,
                child: Stack(children: [
                  Align(
                    alignment: context.locale.languageCode == 'en'
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: const BackButtonWidget(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextWidget(
                      text: LocaleKeys.titles_reset_password.tr(),
                      size: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                  child: isCodeSent
                      ? SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 45.h,
                                ),
                                TextWidget(
                                  text: LocaleKeys.auth_verification_code.tr(),
                                  size: 26,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                SizedBox(
                                  width: 275.w,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    " ${LocaleKeys.auth_code_was_sent.tr()} $finalPhone",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18.sp,
                                      color: kLightDarkBleuColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: PinCodeTextField(
                                      errorTextDirection: TextDirection.rtl,
                                      errorTextSpace: 20.h,
                                      length: 4,
                                      controller: pinController,
                                      obscureText: false,
                                      animationType: AnimationType.fade,
                                      showCursor: true,
                                      cursorColor: kBlueColor,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.circle,
                                        fieldHeight: 80.h,
                                        fieldWidth: 80.w,
                                        errorBorderColor: Colors.red,
                                        activeFillColor: kBlueColor,
                                        inactiveFillColor: kLightLightGreyColor,
                                        inactiveColor: kLightLightGreyColor,
                                        activeColor: kLightLightGreyColor,
                                        selectedFillColor: kLightLightGreyColor,
                                        disabledColor: kLightLightGreyColor,
                                        selectedColor: kBlueColor,
                                      ),
                                      enabled: true,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                      onCompleted: (v) async {},
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return LocaleKeys
                                              .auth_enter_code_please
                                              .tr();
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {},
                                      appContext: context,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/lock.svg",
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        TextWidget(
                                          text: LocaleKeys.auth_password.tr(),
                                          size: 16,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: !isPassVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return LocaleKeys
                                              .auth_enter_valid_password
                                              .tr();
                                        }

                                        if (value !=
                                            confirmPassController.text) {
                                          return LocaleKeys
                                              .auth_password_not_matching
                                              .tr();
                                        }
                                        return null;
                                      },
                                      decoration: formFieldDecoration!.copyWith(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isPassVisible = !isPassVisible;
                                            });
                                          },
                                          child: Icon(
                                            Icons.visibility,
                                            color: !isPassVisible
                                                ? kOrangeColor
                                                : kGreenColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 35.h,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/lock.svg"),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        TextWidget(
                                          text: LocaleKeys.auth_confirm_password
                                              .tr(),
                                          size: 16,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    TextFormField(
                                      controller: confirmPassController,
                                      obscureText: !isPassConfVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return LocaleKeys
                                              .auth_enter_valid_password
                                              .tr();
                                        }

                                        if (value !=
                                            confirmPassController.text) {
                                          return LocaleKeys
                                              .auth_password_not_matching
                                              .tr();
                                        }
                                        return null;
                                      },
                                      decoration: formFieldDecoration!.copyWith(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isPassConfVisible =
                                                  !isPassConfVisible;
                                            });
                                          },
                                          child: Icon(
                                            Icons.visibility,
                                            color: !isPassConfVisible
                                                ? kOrangeColor
                                                : kGreenColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 100.h,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await AuthController.resetPassword(
                                              phone: finalPhone,
                                              password: passwordController.text,
                                              otp: double.parse(
                                                  pinController.text),
                                              language:
                                                  context.locale.languageCode)
                                          .then((value) {
                                        isLoading = false;
                                        setState(() {});

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            backgroundColor: value.toString() ==
                                                    "شكرا لك لتغير كلمه المرور بنجاح"
                                                ? kBlueColor
                                                : Colors.red,
                                            content: Text(
                                              value.toString(),
                                            ),
                                          ),
                                        );
                                        if (value.toString() ==
                                            "شكرا لك لتغير كلمه المرور بنجاح") {
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  },
                                  child: LargeButton(
                                      text: LocaleKeys.auth_save.tr(),
                                      isButton: false),
                                )
                              ],
                            ),
                          ),
                        )
                      //////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      ////////////////////////////////////////////////
                      /////////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      ////////////////////////////////////////////////
                      /////////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      ////////////////////////////////////////////////
                      /////////////////////////////////////////////////////
                      /////////////////////////////////////////////////
                      ////////////////////////////////////////////////
                      : SingleChildScrollView(
                          child: Form(
                            key: _formKey2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50.h,
                                ),
                                SizedBox(
                                    height: 200.h,
                                    child: Image.asset(
                                        "assets/images/reset_password.png")),
                                SizedBox(
                                  height: 30.h,
                                ),
                                TextWidget(
                                  text: LocaleKeys.auth_did_you_forgot_password
                                      .tr(),
                                  size: 18,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                TextWidget(
                                  text:
                                      LocaleKeys.auth_enter_phone_to_reset.tr(),
                                  size: 18,
                                  color: kLightDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                SizedBox(
                                  height: 60.h,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 15.sp,
                                      color: kOrangeColor,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      LocaleKeys.auth_phone_number.tr(),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16.sp,
                                        color: kDarkBleuColor,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.5.h),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IntlPhoneField(
                                    decoration: formFieldDecoration!,
                                    initialCountryCode: 'SA',
                                    keyboardType: TextInputType.phone,
                                    showDropdownIcon: true,
                                    disableLengthCheck: true,
                                    dropdownIcon: const Icon(
                                      Icons.abc,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (value) {
                                      var temp =
                                          value.countryCode + value.number;
                                      finalPhone = temp.replaceFirst("+", "");
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      String pattern = r'[0-9]';
                                      RegExp regExp = RegExp(pattern);

                                      if (value == null ||
                                          value.number.isEmpty ||
                                          !regExp.hasMatch(value.number)) {
                                        return LocaleKeys
                                            .auth_enter_valid_phone_number
                                            .tr();
                                      }
                                      if (value.number.length != 9) {
                                        return LocaleKeys.auth_phone_must_be_9
                                            .tr();
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 70.h,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_formKey2.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await AuthController.forgotPassword(
                                              finalPhone,
                                              context.locale.languageCode)
                                          .then((value) {
                                        isLoading = false;
                                        setState(() {});
                                        if (value.length != 4) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                value.toString(),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     duration:
                                          //         const Duration(seconds: 3),
                                          //     backgroundColor: kBlueColor,
                                          //     content: Text(
                                          //       value.toString(),
                                          //     ),
                                          //   ),
                                          // );
                                          if (value.toString().length == 4 &&
                                              value.toString() != 'null') {
                                            isCodeSent = true;
                                            setState(() {});
                                          }
                                        }
                                      });
                                    }
                                  },
                                  child: LargeButton(
                                    text: LocaleKeys.common_continue.tr(),
                                    isButton: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
