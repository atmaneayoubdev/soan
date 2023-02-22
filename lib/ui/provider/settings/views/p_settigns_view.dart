import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/auth_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/signin_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/settings_widget.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../controllers/global_controller.dart';
import '../../../../models/global/info_model.dart';
import '../../../../models/global/settings_model.dart';
import '../../../../models/global/social_model.dart';
import 'p_profile_view.dart';
import 'deus_view.dart';
import '../../../../Common/title_widget.dart';
import '../../../customer/orders/components/rating_heading_widget.dart';
import '../../../customer/settings/views/faq_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../customer/settings/views/suggestions_view.dart';
import '../../../customer/settings/views/terms_and_condition_view.dart';

class PsettingsView extends StatefulWidget {
  const PsettingsView({Key? key}) : super(key: key);

  @override
  State<PsettingsView> createState() => _PsettingsViewState();
}

class _PsettingsViewState extends State<PsettingsView> {
  late ProviderModel provider;
  bool isLoading = false;

  late SettingsModel settingsModel = SettingsModel(
      social: SocialModel(facebook: "", instagram: "", twitter: ''),
      info: InfoModel(
          appName: '', phone: '', whatsapp: '', email: '', vat: '', dues: ''));

  Future getSettings() async {
    if (mounted) {
      await GlobalController.getSettings(context.locale.languageCode)
          .then((value) {
        settingsModel = value;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    provider =
        Provider.of<ProviderProvider>(context, listen: false).providerModel;
    Future.delayed(Duration.zero, () {
      getSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset("assets/images/home_back.png"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 63.h,
            ),
            TitleWidget(
              title: LocaleKeys.titles_settings.tr(),
              isProvider: true,
            ),
            SizedBox(
              height: 20.h,
            ),
            RatingHeaderWidget(
              provdier: provider,
            ),
            SizedBox(
              height: 20.w,
            ),
            Expanded(
              // width: 350.w,
              // height: 400.h,
              child: SizedBox(
                width: 350.w,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.w,
                  mainAxisSpacing: 30.h,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PprofileView(),
                          ),
                        );
                      },
                      child: SettingsWidget(
                        image: "assets/icons/contact_placeholder.svg",
                        name:
                            LocaleKeys.costumer_settings_personal_profile.tr(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DuesView(),
                          ),
                        );
                      },
                      child: SettingsWidget(
                        image: "assets/icons/wallet.svg",
                        name: LocaleKeys.titles_dues.tr(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const FaqView()),
                          ),
                        );
                      },
                      child: SettingsWidget(
                        name: LocaleKeys.titles_faq.tr(),
                        image: "assets/icons/faq.svg",
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: SettingsWidget(
                    //       name: LocaleKeys.costumer_settings_rate_app.tr(),
                    //       image: "assets/icons/settings_star.svg"),
                    // ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const TermsAndConditionView())));
                      },
                      child: SettingsWidget(
                          name: LocaleKeys.titles_terms.tr(),
                          image: "assets/icons/terms_and_conditions.svg"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchUrl(
                          Uri.parse(
                            "whatsapp://send?text=sample text&phone=${settingsModel.info.whatsapp}",
                          ),
                        );
                      },
                      child: SettingsWidget(
                          name: LocaleKeys.costumer_settings_technical_support
                              .tr(),
                          image: "assets/icons/whatsapp.svg"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchUrl(Uri.parse(settingsModel.social.instagram));
                      },
                      child: SettingsWidget(
                          name: LocaleKeys.costumer_settings_instagram.tr(),
                          image: "assets/icons/instagram.svg"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchUrl(Uri.parse(settingsModel.social.twitter));
                      },
                      child: SettingsWidget(
                          name: LocaleKeys.costumer_settings_twitter.tr(),
                          image: "assets/icons/twitter.svg"),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                height: 150.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.setLocale(const Locale("en"));

                                        setState(() {});
                                      },
                                      child: Container(
                                        //width: 175.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          color: ctx.locale.languageCode == 'en'
                                              ? kBlueColor
                                              : kLightLightBlueColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "English",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.normal,
                                              color: ctx.locale.languageCode ==
                                                      'en'
                                                  ? Colors.white
                                                  : kDarkBleuColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.setLocale(const Locale("ar"));
                                        setState(() {});
                                      },
                                      child: Container(
                                        //width: 175.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          color: ctx.locale.languageCode == 'ar'
                                              ? kBlueColor
                                              : kLightLightBlueColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "العربية",
                                            style: GoogleFonts.tajawal(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.normal,
                                              color: ctx.locale.languageCode ==
                                                      'ar'
                                                  ? Colors.white
                                                  : kDarkBleuColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        // height: 123.w,
                        width: 95.w,
                        child: Column(children: [
                          Container(
                            height: 95.h,
                            width: 95.w,
                            decoration: BoxDecoration(
                              color: kLightLightGreyColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.language,
                                color: kBlueColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FittedBox(
                            child: TextWidget(
                              text: LocaleKeys.costumer_settings_language.tr(),
                              size: 14,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const SuggestionsView(
                                      isProvider: true,
                                    ))));
                      },
                      child: SettingsWidget(
                          name: LocaleKeys.titles_suggestions.tr(),
                          image: "assets/icons/suggestions.svg"),
                    ),
                    GestureDetector(
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        await AuthController.logout(
                          language: context.locale.languageCode,
                          token: Provider.of<ProviderProvider>(context,
                                  listen: false)
                              .providerModel
                              .apiToken,
                        ).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value == 'تم تسجيل الخروج' || value == 'LogOut') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kBlueColor,
                                content: Text(
                                  value.toString(),
                                ),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInView()),
                                (route) => false);
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
                      },
                      child: SizedBox(
                        // height: 123.w,
                        width: 95.w,
                        child: Column(children: [
                          Container(
                            height: 95.h,
                            width: 95.w,
                            decoration: BoxDecoration(
                                color: kLightLightPinkColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                                child: SvgPicture.asset(
                              "assets/icons/logout.svg",
                            )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FittedBox(
                            child: TextWidget(
                              text: LocaleKeys.costumer_settings_logout.tr(),
                              size: 14,
                              color: kPinkColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        modal
                            .showMaterialModalBottomSheet<bool>(
                          enableDrag: false,
                          backgroundColor: Colors.transparent,
                          context: context,
                          isDismissible: true,
                          builder: (context) => Center(
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(
                                      child: Text(
                                    LocaleKeys
                                        .costumer_settings_your_account_will_be_deleted
                                        .tr(),
                                    maxLines: 5,
                                    softWrap: true,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: kDarkBleuColor,
                                    ),
                                  )),
                                  // SizedBox(
                                  //   height: 20.h,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Container(
                                            width: 175.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10.r,
                                              ),
                                              color: kLightLightBlueColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                LocaleKeys.common_cancel.tr(),
                                                style: GoogleFonts.tajawal(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: kDarkBleuColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: LargeButton(
                                              text:
                                                  LocaleKeys.auth_confirm.tr(),
                                              isButton: false,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            .then((value) async {
                          if (value == true) {
                            isLoading = true;
                            setState(() {});
                            await AuthController.deleteAccount(
                                    language: context.locale.languageCode,
                                    token: Provider.of<ProviderProvider>(
                                            context,
                                            listen: false)
                                        .providerModel
                                        .apiToken,
                                    type: "provider")
                                .then((value) async {
                              isLoading = false;
                              setState(() {});
                              if (value == "تم مسح الحساب" ||
                                  value == 'Your Account Has Deleted') {
                                Provider.of<ProviderProvider>(context,
                                        listen: false)
                                    .clearUser();
                                Provider.of<ProviderProvider>(context,
                                        listen: false)
                                    .clearUser();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: kBlueColor,
                                    content: Text(
                                      value.toString(),
                                    ),
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const SignInView(),
                                  ),
                                  (route) => false,
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
                        });
                      },
                      child: SizedBox(
                        // height: 123.w,
                        width: 95.w,
                        child: Column(children: [
                          Container(
                            height: 95.h,
                            width: 95.w,
                            decoration: BoxDecoration(
                                color: kLightLightPinkColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: const Center(
                                child: Icon(
                              Icons.delete_outline_rounded,
                              color: kPinkColor,
                            )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          FittedBox(
                            child: TextWidget(
                              text: LocaleKeys.costumer_settings_delete_account
                                  .tr(),
                              size: 14,
                              color: kPinkColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
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
