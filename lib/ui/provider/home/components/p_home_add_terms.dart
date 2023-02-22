import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../views/add_terms_view.dart';

class PhomeAddTerms extends StatefulWidget {
  const PhomeAddTerms({
    Key? key,
    required this.skip,
  }) : super(key: key);

  final Function() skip;

  @override
  State<PhomeAddTerms> createState() => _PhomeAddTermsState();
}

class _PhomeAddTermsState extends State<PhomeAddTerms> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 682.h,
        width: 385.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 5,
                color: kLightLightGreyColor,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/add_terms_conditions.png",
              height: 191.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            TextWidget(
              text: LocaleKeys.titles_add_terms.tr(),
              size: 16,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              width: 328.h,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const AddTermsAndConditions())));
                  },
                  child: LargeButton(
                      text: LocaleKeys.common_add.tr(), isButton: false)),
            ),
            10.verticalSpace,
            Center(
              child: SizedBox(
                width: 350.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 328.h,
                      child: GestureDetector(
                          onTap: () {
                            widget.skip();
                          },
                          child: LargeButton(
                            text: LocaleKeys.intoduction_skip.tr(),
                            isButton: false,
                          )),
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15.h,
                          width: 15.w,
                          decoration: const BoxDecoration(
                            color: kPinkColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: Text(
                            LocaleKeys.provider_home_if_you_skip.tr(),
                            style: GoogleFonts.tajawal(
                                fontSize: 16.sp, color: kDarkBleuColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
