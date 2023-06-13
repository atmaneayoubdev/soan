import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/costumer_controller.dart';
import '../components/rating_heading_widget.dart';

class RatingView extends StatefulWidget {
  const RatingView({Key? key, required this.order}) : super(key: key);
  final OrderModel order;

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  TextEditingController message = TextEditingController();
  int rating = 3;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: kBlueColor,
              height: 300.h,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        text: LocaleKeys.titles_rate_provider.tr(),
                        size: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 50.h),
                RatingHeaderWidget(
                  provdier: widget.order.provider!,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  width: 385.w,
                  //height: 342.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 30.h,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 3),
                          spreadRadius: 5,
                          blurRadius: 2,
                          color: kLightLightGreyColor,
                        )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: LocaleKeys.costumer_my_orders_your_opinion_matters
                            .tr(),
                        size: 18,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 0.h,
                      ),
                      TextWidget(
                        text: LocaleKeys
                            .costumer_my_orders_tell_us_your_experience
                            .tr(),
                        size: 18,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        unratedColor: kLightLightSkyBlueColor,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 50.h,
                        onRatingUpdate: (newRating) {
                          rating = newRating.toInt();
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        height: 120.h,
                        width: 313.w,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: kLightLightGreyColor,
                          borderRadius: BorderRadius.circular(9.r),
                        ),
                        child: Stack(
                          children: [
                            TextField(
                              controller: message,
                              maxLines: null,
                              style: GoogleFonts.tajawal(
                                fontSize: 16.sp,
                                color: kDarkBleuColor,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                hintStyle: GoogleFonts.tajawal(
                                  color: kLightDarkBleuColor,
                                  fontSize: 14.sp,
                                ),
                                hintText: LocaleKeys
                                    .costumer_my_orders_write_your_comment_here
                                    .tr(),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                isLoading
                    ? const CircularProgressIndicator(
                        color: kBlueColor,
                      )
                    : GestureDetector(
                        onTap: () async {
                          log(rating.toString());
                          isLoading = true;
                          setState(() {});
                          await CostumerController.rateProvider(
                                  language: context.locale.languageCode,
                                  token: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user
                                      .apiToken,
                                  providerId: widget.order.provider!.id,
                                  rate: rating,
                                  message: message.text,
                                  orderId: widget.order.id)
                              .then((value) {
                            isLoading = false;
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kBlueColor,
                                content: Text(
                                  value,
                                ),
                              ),
                            );
                            if (value == "شكرا لك" || value == 'Thanks') {
                              Navigator.pop(context, true);
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 45.w),
                          child: LargeButton(
                            text: LocaleKeys.costumer_my_orders_rate.tr(),
                            isButton: true,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
