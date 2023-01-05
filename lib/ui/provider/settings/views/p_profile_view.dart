import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'p_account_data_view.dart';
import 'p_change_number_view.dart';
import 'p_change_pass_view.dart';

class PprofileView extends StatefulWidget {
  const PprofileView({Key? key}) : super(key: key);

  @override
  State<PprofileView> createState() => _PprofileViewState();
}

class _PprofileViewState extends State<PprofileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 67.h,
              ),
              const BackButtonWidget(),
              SizedBox(
                height: 93.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 93.h,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: LocaleKeys.titles_account_info.tr(),
                            size: 18,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const PaccountDataView())));
                            },
                            child: Container(
                              height: 23.h,
                              width: 74.w,
                              decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      LocaleKeys.costumer_settings_change.tr(),
                                  size: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(),
                      SizedBox(
                        height: 60.h,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: LocaleKeys.titles_change_number.tr(),
                            size: 18,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const PchangeNumberView())));
                            },
                            child: Container(
                              height: 23.h,
                              width: 74.w,
                              decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      LocaleKeys.costumer_settings_change.tr(),
                                  size: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(),
                      SizedBox(
                        height: 60.h,
                      ),
                      Row(
                        children: [
                          TextWidget(
                            text: LocaleKeys.titles_change_password.tr(),
                            size: 18,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const PchangePassView())),
                              );
                            },
                            child: Container(
                              height: 23.h,
                              width: 74.w,
                              decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text:
                                      LocaleKeys.costumer_settings_change.tr(),
                                  size: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 140.h,
              ),
              Container(
                height: 90.h,
                width: 90.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<ProviderProvider>(context, listen: true)
                            .providerModel
                            .avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: SvgPicture.asset(
                        "assets/icons/contact_placeholder.svg",
                        color: kBlueColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: SvgPicture.asset(
                        "assets/icons/contact_placeholder.svg",
                        color: kBlueColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}