import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePassView extends StatefulWidget {
  const ChangePassView({Key? key}) : super(key: key);

  @override
  State<ChangePassView> createState() => _ChangePassViewState();
}

class _ChangePassViewState extends State<ChangePassView> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPassVisible = false;
  bool isPassConfVisible = false;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Column(
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
                  text: LocaleKeys.titles_change_password.tr(),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 45.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: LocaleKeys.costumer_settings_current_password
                              .tr(),
                          size: 16,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        TextFormField(
                          controller: oldPasswordController,
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
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: LocaleKeys.costumer_settings_new_password.tr(),
                          size: 16,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPassVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.auth_enter_valid_password.tr();
                            }
                            if (value.length < 8) {
                              return LocaleKeys
                                  .auth_password_must_be_longer_than_8
                                  .tr();
                            }

                            if (value != confirmPassController.text) {
                              return LocaleKeys.auth_password_not_matching.tr();
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
                                color:
                                    isPassVisible ? kOrangeColor : kGreenColor,
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
                        TextWidget(
                          text: LocaleKeys
                              .costumer_settings_confirm_new_password
                              .tr(),
                          size: 16,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        TextFormField(
                          controller: confirmPassController,
                          obscureText: !isPassConfVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.auth_enter_valid_password.tr();
                            }
                            if (value.length < 8) {
                              return LocaleKeys
                                  .auth_password_must_be_longer_than_8
                                  .tr();
                            }

                            if (value != confirmPassController.text) {
                              return LocaleKeys.auth_password_not_matching.tr();
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
                                color: isPassConfVisible
                                    ? kOrangeColor
                                    : kGreenColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 260.h,
                    ),
                    isLoading
                        ? SizedBox(
                            height: 100.h,
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: kBlueColor,
                            )),
                          )
                        : GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                await CostumerController.updatePassword(
                                        language: context.locale.languageCode,
                                        token: user.apiToken,
                                        oldPassword: oldPasswordController.text,
                                        password: passwordController.text,
                                        passwordConfirmation:
                                            confirmPassController.text)
                                    .then((value) {
                                  isLoading = false;
                                  setState(() {});
                                  if (value.toString() ==
                                          'تم تغير كلمه المرور' ||
                                      value.toString() ==
                                          'Your Password Has Been Changed') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: kBlueColor,
                                        content: Text(
                                          value.toString(),
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
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
                                text: LocaleKeys.auth_save.tr(),
                                isButton: false))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
