import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/costumer_controller.dart';
import '../../../../helpers/user_provider.dart';
import '../../../../models/auth/user_model.dart';

class ChangeNumberView extends StatefulWidget {
  const ChangeNumberView({Key? key}) : super(key: key);

  @override
  State<ChangeNumberView> createState() => _ChangeNumberViewState();
}

class _ChangeNumberViewState extends State<ChangeNumberView> {
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late UserModel user;
  bool isPassVisible = false;
  bool isLoading = false;
  String finalPhone = '';

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
                  text: LocaleKeys.titles_change_number.tr(),
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: LocaleKeys.costumer_settings_new_phone_number
                              .tr(),
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
                          text: LocaleKeys.auth_password.tr(),
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
                              FocusManager.instance.primaryFocus!.unfocus();
                              if (_formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                await CostumerController.updatePhone(
                                  token: user.apiToken,
                                  phone: finalPhone,
                                  password: passwordController.text,
                                ).then((value) {
                                  isLoading = false;
                                  setState(() {});
                                  if (value == 'تم تغير الجوال') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: kBlueColor,
                                        content: Text(
                                          LocaleKeys
                                              .costumer_settings_phone_number_was_changed
                                              .tr(),
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
