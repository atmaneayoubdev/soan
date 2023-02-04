import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../Common/large_button.dart';
import '../../../constants.dart';
import '../../Authentication/views/signin_view.dart';
import '../components/slider_tile.dart';
import '../components/slider_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({Key? key}) : super(key: key);
  static const String routeName = '/intro';

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  PageController? controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 5.h,
      width: isCurrentPage ? 28.h : 14.h,
      decoration: isCurrentPage
          ? BoxDecoration(
              color: kBlueColor,
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              color: kLightBlueColor,
              borderRadius: BorderRadius.circular(12),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 926.h,
                  child: PageView(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        slideIndex = index;
                      });
                    },
                    children: <Widget>[
                      SlideTile(
                        imagePath: mySLides[0].getImageAssetPath(),
                        desc: mySLides[0].getDesc(),
                      ),
                      SlideTile(
                        imagePath: mySLides[1].getImageAssetPath(),
                        desc: mySLides[1].getDesc(),
                      ),
                      SlideTile(
                        imagePath: mySLides[2].getImageAssetPath(),
                        desc: mySLides[2].getDesc(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 490.h,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 50.h,
                    ),
                    child: Align(
                      alignment: context.locale.languageCode == "en"
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: FittedBox(
                        child: TextButton(
                          onPressed: () {
                            controller!.animateToPage(2,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.linear);
                          },
                          child: Center(
                            child: Text(
                              LocaleKeys.intoduction_skip.tr(),
                              style: GoogleFonts.tajawal(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.normal,
                                color: kDarkBleuColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 270.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                      SizedBox(
                        height: 45.h,
                      ),
                      if (slideIndex == 2)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, SignInView.routeName);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45.w),
                            child: LargeButton(
                              text: LocaleKeys.intoduction_start_now.tr(),
                              isButton: false,
                            ),
                          ),
                        ),
                      if (slideIndex < 2)
                        SizedBox(
                          height: 80.h,
                          width: 80.w,
                          child: Stack(
                            children: [
                              CircularPercentIndicator(
                                radius: 40.h,
                                lineWidth: 2.h,
                                percent: slideIndex == 0 ? 0.3 : 0.6,
                                animation: true,
                                addAutomaticKeepAlive: true,
                                animateFromLastPercent: true,
                                backgroundColor: kLightSkyBleuColor,
                                center: Container(
                                  height: 60.h,
                                  width: 60.w,
                                  padding: EdgeInsets.all(15.h),
                                  decoration: const BoxDecoration(
                                    color: kBlueColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (slideIndex < 2) {
                                          slideIndex++;
                                          controller!.animateToPage(
                                            slideIndex,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            curve: Curves.linear,
                                          );
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/circular_arrow.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                progressColor: kBlueColor,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
