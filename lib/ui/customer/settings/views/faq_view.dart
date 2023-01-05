import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqView extends StatefulWidget {
  const FaqView({Key? key}) : super(key: key);

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
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
                  text: LocaleKeys.titles_faq.tr(),
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
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextWidget(
                    text: LocaleKeys.costumer_settings_long_faq.tr(),
                    size: 20,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    "adfsdfalkds fkjajsd jfka jsdf jflkj lasdasf lsdjflkaj sdf f alskdjflk j;laksjd;flkja;lksdjf j;alsdj;lfj lajsghaskdf hjj lajsdf hasjkgajeior a;iorgj sgdsf",
                    style: GoogleFonts.tajawal(
                      fontSize: 14.sp,
                      color: kGreyColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
