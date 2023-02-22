import 'dart:math';

import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soan/Common/back_button.dart';
import 'package:soan/Common/large_button.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/Common/text_widget.dart';
import 'package:soan/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/Common/how_to_know_us_widget.dart';
import 'package:soan/ui/Authentication/views/signin_view.dart';
import 'package:soan/ui/Authentication/views/user_second_signup_view.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../controllers/global_controller.dart';

class UserFirstSignUpView extends StatefulWidget {
  const UserFirstSignUpView({Key? key}) : super(key: key);
  static const String routeName = "/signup_user";

  @override
  State<UserFirstSignUpView> createState() => _UserFirstSignUpViewState();
}

class _UserFirstSignUpViewState extends State<UserFirstSignUpView> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<HowToKnowUsModel> howToKnowUsList = [];
  HowToKnowUsModel? _selectedHowToKnowUsModel;
  bool isHowError = false;
  String finalPhone = '';

  bool agreeOnTermsAndConditions = false;
  bool isLoading = true;

  Future getHowToKnowUsList() async {
    await GlobalController.getHowToKnowUsList(context.locale.languageCode)
        .then((value) {
      howToKnowUsList = value;

      if (value.isNotEmpty) {
        _selectedHowToKnowUsModel = howToKnowUsList.first;
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getHowToKnowUsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //isLoading = false;
    return Scaffold(
      body: Stack(
        children: [
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
                height: 65.h,
              ),
              const BackButtonWidget(),
              SizedBox(
                height: 125.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(80.r)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 31.h,
                        ),
                        TextWidget(
                          text: LocaleKeys.titles_create_account.tr(),
                          size: 26,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: "  ${LocaleKeys.auth_first_name.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: firstNameController,
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys
                                        .auth_please_enter_first_name
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text: "   ${LocaleKeys.auth_last_name.tr()}   ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              TextFormField(
                                controller: lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LocaleKeys
                                        .auth_please_enter_last_name
                                        .tr();
                                  }
                                  return null;
                                },
                                decoration: formFieldDecoration,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_phone_number.tr()}  ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
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
                                  autovalidateMode: AutovalidateMode.always,
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
                                height: 12.h,
                              ),
                              TextWidget(
                                text:
                                    "  ${LocaleKeys.auth_how_you_know_us.tr()} ",
                                size: 16,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              SizedBox(
                                height: 70.h,
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: howToKnowUsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    HowToKnowUsModel howToKnowUsModel =
                                        howToKnowUsList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isHowError = false;
                                          _selectedHowToKnowUsModel =
                                              howToKnowUsModel;
                                        });
                                      },
                                      child: HowToKnowUsWidgt(
                                        isError: isHowError,
                                        name: howToKnowUsModel.name,
                                        isActive: _selectedHowToKnowUsModel ==
                                                howToKnowUsModel
                                            ? true
                                            : false,
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width: 20.w,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 44.h,
                              ),
                              SizedBox(
                                height: 22.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          agreeOnTermsAndConditions =
                                              !agreeOnTermsAndConditions;
                                        });
                                      },
                                      child: Container(
                                        width: 22.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                              color: kBlueColor,
                                            )),
                                        child: agreeOnTermsAndConditions
                                            ? const FittedBox(
                                                child: Icon(
                                                  Icons.check,
                                                  color: kBlueColor,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    TextWidget(
                                      text: LocaleKeys
                                          .auth_agree_terms_and_conditions
                                          .tr(),
                                      size: 14,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(
                                      width: context.locale.languageCode == 'en'
                                          ? 30.h
                                          : 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible:
                                              true, // user must tap button!
                                          builder: (BuildContext ctx) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.zero,
                                              content: Container(
                                                height: 800.h,
                                                width: 350.w,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: SingleChildScrollView(
                                                  child: FutureBuilder(
                                                    future: GlobalController
                                                        .getPrivacy(context
                                                            .locale
                                                            .languageCode),
                                                    initialData: '',
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                      return Text(
                                                        snapshot.data
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.tajawal(
                                                          height: 1.5,
                                                          fontSize: 16.sp,
                                                          color: kGreyColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Transform(
                                        transform:
                                            context.locale.languageCode == 'en'
                                                ? Matrix4.rotationY(pi)
                                                : Matrix4.rotationY(0),
                                        child: SvgPicture.asset(
                                          "assets/icons/question_circle.svg",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate() &&
                                      agreeOnTermsAndConditions) {
                                    if (_selectedHowToKnowUsModel != null) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            UserSecondSignUpView(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phone: finalPhone,
                                          howToKnowUs: int.parse(
                                              _selectedHowToKnowUsModel!.id),
                                        ),
                                      ));
                                    }
                                  }
                                },
                                child: LargeButton(
                                    text: LocaleKeys.auth_create.tr(),
                                    isButton: false),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Center(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color: kGreenColor,
                                              fontSize: 16.sp),
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
                      ],
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
