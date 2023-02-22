import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soan/Common/back_button.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../constants.dart';
import 'provider_first_register_view.dart';
import 'user_first_signup_view.dart';

class SignUpTypeView extends StatefulWidget {
  const SignUpTypeView({Key? key}) : super(key: key);
  static const String routeName = "/signup_type";

  @override
  State<SignUpTypeView> createState() => _SignUpTypeViewState();
}

class _SignUpTypeViewState extends State<SignUpTypeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          children: [
            Container(
              height: 720.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/signup_background.png",
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButtonWidget(),
                  20.verticalSpace,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 27.w),
                    child: Text(
                      LocaleKeys.auth_welcome_to_soan.tr(),
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        30.verticalSpace,
        Center(
          child: Text(
            LocaleKeys.titles_create_account.tr(),
            style: GoogleFonts.tajawal(
              color: kDarkBleuColor,
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        30.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(UserFirstSignUpView.routeName);
              },
              child: Container(
                width: 162.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.r,
                  ),
                  color: kBlueColor,
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.auth_costumer.tr(),
                    style: GoogleFonts.tajawal(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProviderFirstRegisterView(),
                  ),
                );
              },
              child: Container(
                width: 162.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.r,
                  ),
                  color: kLightLightBlueColor,
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.auth_provider.tr(),
                    style: GoogleFonts.tajawal(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: kDarkBleuColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}
