import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/auth_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/reset_password_view.dart';
import 'package:soan/ui/provider/p_landing_view.dart';
import '../../../Common/large_button.dart';
import '../../../constants.dart';
import 'signup_type_view.dart';
import '../../customer/landing_view.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);
  static const String routeName = "/singin";

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String finalPhone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      body: Stack(clipBehavior: Clip.none, children: [
        Container(
          height: 418.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/images/singin_background.png",
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70.h,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 26.w),
            //   child: SvgPicture.asset('assets/icons/back_button.svg'),
            // ),
            SizedBox(
              height: 78.h,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/icons/soan_logo.svg',
                height: 118.h,
              ),
            ),
            SizedBox(
              height: 55.h,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70.r),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35.h,
                        ),
                        Center(
                          child: Text(
                            LocaleKeys.titles_singin.tr(),
                            style: GoogleFonts.tajawal(
                                fontSize: 26.sp,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
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
                            controller: phoneController,
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
                              var temp = value.countryCode + value.number;
                              finalPhone = temp.replaceFirst("+", "");
                            },
                            onCountryChanged: (value) {
                              finalPhone = '';
                              phoneController.clear();
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String pattern = r'[0-9]';
                              RegExp regExp = RegExp(pattern);

                              if (value == null ||
                                  value.number.isEmpty ||
                                  !regExp.hasMatch(value.number)) {
                                return LocaleKeys.auth_enter_valid_phone_number
                                    .tr();
                              }
                              if (value.number.length != 9) {
                                return LocaleKeys.auth_phone_must_be_9.tr();
                              }

                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 34.h),
                        Row(
                          children: [
                            Icon(
                              Icons.lock,
                              size: 15.sp,
                              color: kOrangeColor,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              LocaleKeys.auth_password.tr(),
                              style: GoogleFonts.tajawal(
                                fontSize: 16.sp,
                                color: kDarkBleuColor,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.5.h),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.auth_enter_valid_password.tr();
                            }

                            if (value.length < 8) {
                              return LocaleKeys
                                  .auth_password_must_be_longer_than_8
                                  .tr();
                            }
                            return null;
                          },
                          decoration: formFieldDecoration,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResetPasswordView(),
                              ),
                            );
                          },
                          child: Text(
                            LocaleKeys.auth_i_forgot_password.tr(),
                            style: GoogleFonts.tajawal(
                              fontSize: 16.sp,
                              color: kPinkColor,
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              log(finalPhone);
                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                await AuthController.login(
                                        phoneNumber: finalPhone,
                                        password: passwordController.text)
                                    .then((value) async {
                                  isLoading = false;
                                  setState(() {});
                                  log(value.runtimeType.toString());
                                  if (value.runtimeType == UserModel) {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .setUser(value);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LandingView()),
                                        (Route<dynamic> route) => false);
                                  } else if (value.runtimeType ==
                                      ProviderModel) {
                                    final ProviderModel p = value;
                                    if (p.approved == "false") {
                                      await AuthController.logout(
                                        token: p.apiToken,
                                      ).then((value) {
                                        if (value == 'تم تسجيل الخروج') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                LocaleKeys
                                                    .auth_account_under_review
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
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: LargeButton(
                                text: LocaleKeys.auth_enter.tr(),
                                isButton: false)),
                        SizedBox(
                          height: 37.h,
                        ),
                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                SignUpTypeView.routeName,
                              );
                            },
                            child: Container(
                              height: 51.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: kBlueColor),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '   ${LocaleKeys.auth_have_no_account.tr()}   ',
                                    style: GoogleFonts.tajawal(
                                      color: kDarkBleuColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.titles_create_account.tr(),
                                    style: GoogleFonts.tajawal(
                                        color: kGreenColor, fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isLoading) const LoadingWidget(),
      ]),
    );
  }
}
