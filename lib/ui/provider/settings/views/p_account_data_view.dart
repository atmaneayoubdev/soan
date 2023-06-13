// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaccountDataView extends StatefulWidget {
  const PaccountDataView({Key? key}) : super(key: key);

  @override
  State<PaccountDataView> createState() => _PaccountDataViewState();
}

class _PaccountDataViewState extends State<PaccountDataView> {
  TextEditingController providerNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late ProviderModel providerModel;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  String photo = "";
  List<File> imgs = [];

  @override
  void initState() {
    super.initState();
    providerModel =
        Provider.of<ProviderProvider>(context, listen: false).providerModel;
    providerNameController.text = providerModel.providerName;
    emailController.text = providerModel.email;
    photo = providerModel.avatar;
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
                                    imageUrl: providerModel.avatar,
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
                                    .pickImage(
                                  source: ImageSource.gallery,
                                )
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
                          text: LocaleKeys.auth_workshop_name.tr(),
                          size: 16,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        TextFormField(
                          controller: providerNameController,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.auth_enter_company_name.tr();
                            }
                            return null;
                          },
                          decoration: formFieldDecoration,
                        ),
                      ],
                    ),
                    const Spacer(),
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
                                await ProviderController.updateProfile(
                                        language: context.locale.languageCode,
                                        token: providerModel.apiToken,
                                        providerName:
                                            providerNameController.text,
                                        image: imgs.isEmpty ? null : imgs.first)
                                    .then((value) {
                                  isLoading = false;
                                  setState(() {});
                                  if (value.runtimeType == ProviderModel) {
                                    Provider.of<ProviderProvider>(context,
                                            listen: false)
                                        .setProvider(value);
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                            child: const LargeButton(
                              text: "حفظ",
                              isButton: false,
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
        ],
      ),
    );
  }
}
