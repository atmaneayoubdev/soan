import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/controllers/auth_controller.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/phone_verification.dart';
import '../../../Common/large_button.dart';
import '../../../Common/loading_widget.dart';
import '../../../Common/text_widget.dart';
import '../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_view.dart';

class UserSecondSignUpView extends StatefulWidget {
  const UserSecondSignUpView(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.howToKnowUs})
      : super(key: key);
  final String firstName;
  final String lastName;
  final String phone;
  final int howToKnowUs;

  @override
  State<UserSecondSignUpView> createState() => _UserSecondSignUpViewState();
}

class _UserSecondSignUpViewState extends State<UserSecondSignUpView> {
  TextEditingController emailControlelr = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPassVisible = false;
  bool isPassConfVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 74.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 101.h,
                          ),
                          TextWidget(
                            text: LocaleKeys.titles_finish_data.tr(),
                            size: 26,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: 53.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/email.svg"),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  TextWidget(
                                    text: LocaleKeys.auth_email.tr(),
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
                                controller: emailControlelr,
                                maxLines: 1,
                                validator: (value) {
                                  String pattern =
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$";
                                  RegExp regex = RegExp(pattern);
                                  if (value == null ||
                                      value.isEmpty ||
                                      !regex.hasMatch(value)) {
                                    return LocaleKeys.auth_enter_valid_email
                                        .tr();
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: formFieldDecoration,
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
                                  SvgPicture.asset("assets/icons/lock.svg"),
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
                                    return LocaleKeys.auth_enter_valid_password
                                        .tr();
                                  }

                                  if (value != confirmPassController.text) {
                                    return LocaleKeys.auth_password_not_matching
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
                                  SvgPicture.asset("assets/icons/lock.svg"),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  TextWidget(
                                    text: LocaleKeys.auth_confirm_password.tr(),
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
                                    return LocaleKeys.auth_enter_valid_password
                                        .tr();
                                  }

                                  if (value != passwordController.text) {
                                    return LocaleKeys.auth_password_not_matching
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration!.copyWith(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isPassConfVisible = !isPassConfVisible;
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
                            height: 120.h,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                await AuthController.userRegister(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  phoneNumber: widget.phone,
                                  email: emailControlelr.text,
                                  password: passwordController.text,
                                  passwordConfirm: confirmPassController.text,
                                  deviceToken: "54234343234523",
                                  howToKnowUs: widget.howToKnowUs,
                                ).then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value != "error") {
                                    if (value.toString().length == 4 &&
                                        value.toString() != 'null') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhoneVerification(
                                            from: 'costumer',
                                            number: widget.phone,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            value.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                });
                              }
                            },
                            child: LargeButton(
                              text: LocaleKeys.auth_create.tr(),
                              isButton: false,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    SignInView.routeName,
                                    (Route<dynamic> route) => false);
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
                                      ' ${LocaleKeys.auth_have_an_account.tr()} ',
                                      style: GoogleFonts.tajawal(
                                        color: kDarkBleuColor,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      LocaleKeys.titles_singin.tr(),
                                      style: GoogleFonts.tajawal(
                                          color: kGreenColor, fontSize: 16.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) const LoadingWidget()
        ],
      ),
    );
  }
}
