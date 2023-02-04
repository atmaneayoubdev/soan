import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/p_landing_view.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTermsAndConditions extends StatefulWidget {
  const AddTermsAndConditions({Key? key}) : super(key: key);

  @override
  State<AddTermsAndConditions> createState() => _AddTermsAndConditionsState();
}

class _AddTermsAndConditionsState extends State<AddTermsAndConditions> {
  TextEditingController controller = TextEditingController();
  FocusNode node = FocusNode();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    node.requestFocus();
  }

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
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: BackButtonWidget(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      child: TextWidget(
                        text: LocaleKeys.titles_add_terms.tr(),
                        size: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 22.w,
                            vertical: 30.h,
                          ),
                          height: 606.h,
                          width: 385.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                text: LocaleKeys
                                    .provider_home_shops_terms_and_conditions
                                    .tr(),
                                size: 22,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              const Divider(),
                              Expanded(
                                  child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                focusNode: node,
                                maxLines: null,
                              )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 9.h,
                              width: 9.w,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: kPinkColor),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              LocaleKeys.provider_home_you_wont_change.tr(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                fontSize: 14.sp,
                                color: kPinkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      SizedBox(
                        width: 342.w,
                        child: GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              setState(() {});
                              if (controller.text.isNotEmpty) {
                                await ProviderController.updateTerms(
                                        language: context.locale.languageCode,
                                        token: Provider.of<ProviderProvider>(
                                                context,
                                                listen: false)
                                            .providerModel
                                            .apiToken,
                                        terms: controller.text)
                                    .then((value) async {
                                  isLoading = false;
                                  setState(() {});
                                  if (value ==
                                      'الشروط والأحكام الخاصه بك تم تغيرها بالفعل') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: kBlueColor,
                                        content: Text(
                                          value,
                                        ),
                                      ),
                                    );
                                    await SharedPreferences.getInstance()
                                        .then((value2) {
                                      value2.setString('terms', value);
                                      Provider.of<ProviderProvider>(
                                        context,
                                        listen: false,
                                      ).providerModel.terms = controller.text;

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                const PlandingView(
                                                  selectedIndex: 0,
                                                )),
                                          ),
                                          (route) => false);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: LargeButton(
                                text: LocaleKeys.auth_save.tr(),
                                isButton: true)),
                      ),
                    ],
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
