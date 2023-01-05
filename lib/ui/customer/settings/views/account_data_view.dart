import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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

class AccountDataView extends StatefulWidget {
  const AccountDataView({Key? key}) : super(key: key);

  @override
  State<AccountDataView> createState() => _AccountDataViewState();
}

class _AccountDataViewState extends State<AccountDataView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late UserModel user;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  String photo = "";
  List<File> imgs = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    photo = user.avatar;
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
                  text: LocaleKeys.titles_account_info.tr(),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45.h,
                      ),
                      Container(
                        height: 150.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kLightBlueColor),
                        ),
                        child: Stack(
                          children: [
                            if (imgs.isEmpty)
                              Center(
                                child: Container(
                                  height: 150.h,
                                  width: 150.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 255, 255, 0.17),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(300),
                                    child: CachedNetworkImage(
                                      imageUrl: user.avatar,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/contact_placeholder.svg",
                                          color: kBlueColor,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/contact_placeholder.svg",
                                          color: kBlueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SvgPicture.asset("assets/icons/contact_placeholder.svg"),
                                ),
                              ),
                            if (imgs.isNotEmpty)
                              SizedBox.expand(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(300),
                                  child: Image.file(
                                    imgs.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  await _picker
                                      .pickImage(source: ImageSource.gallery)
                                      .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        imgs.add(File(value.path));
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kDarkBleuColor,
                                  ),
                                  child: const Icon(
                                    Icons.mode_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: LocaleKeys.auth_first_name.tr(),
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
                                return LocaleKeys.auth_please_enter_first_name
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
                            text: LocaleKeys.auth_last_name.tr(),
                            size: 16,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          TextFormField(
                            controller: lastNameController,
                            maxLines: 1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys.auth_please_enter_last_name
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
                      SizedBox(
                        height: 100.h,
                      ),
                      isLoading
                          ? SizedBox(
                              height: 100.h,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: kBlueColor,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                isLoading = true;
                                setState(() {});
                                FocusManager.instance.primaryFocus!.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  await CostumerController.updateProfile(
                                          token: user.apiToken,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          image:
                                              imgs.isEmpty ? null : imgs.first)
                                      .then((value) {
                                    isLoading = false;
                                    setState(() {});
                                    if (value.runtimeType == UserModel) {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .setUser(value);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: kBlueColor,
                                          content: Text(
                                            LocaleKeys
                                                .costumer_settings_user_data_updated
                                                .tr(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
