import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../controllers/provider_controller.dart';
import '../../../../helpers/provider.provider.dart';
import '../../p_landing_view.dart';

class PayementRecievedBottomSheet extends StatefulWidget {
  const PayementRecievedBottomSheet({
    Key? key,
    required this.order,
  }) : super(key: key);
  final PorderModel order;

  @override
  State<PayementRecievedBottomSheet> createState() =>
      _PayementRecievedBottomSheetState();
}

class _PayementRecievedBottomSheetState
    extends State<PayementRecievedBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 400.h,
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
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Container(
                  height: 5.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: kGreyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                'assets/images/payement_recieved.png',
                height: 140.h,
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                child: FittedBox(
                  child: TextWidget(
                    text: LocaleKeys.provider_orders_did_you_get_the_payement
                        .tr(),
                    size: 24,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              setState(() {});
                              await ProviderController.confirmTakeMoney(
                                language: context.locale.languageCode,
                                token: Provider.of<ProviderProvider>(
                                  context,
                                  listen: false,
                                ).providerModel.apiToken,
                                orderId: widget.order.id,
                              ).then((value) {
                                isLoading = false;
                                setState(() {});
                                if (value == "بيانات الطلب" ||
                                    value == 'Order Information') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PlandingView(
                                        selectedIndex: 1,
                                      ),
                                    ),
                                    (route) => false,
                                  ).then((value) async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    if (prefs.getBool('apprated') != null) {
                                      if (prefs.getBool('apprate') == false) {
                                        final InAppReview inAppReview =
                                            InAppReview.instance;

                                        if (await inAppReview.isAvailable()) {
                                          inAppReview.requestReview();
                                        } else {
                                          debugPrint('Rate Not availbale');
                                        }
                                        prefs.setBool('apprate', true);
                                      }
                                    }
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
                            },
                            child: Container(
                              height: 55.h,
                              width: 175.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                                color: kBlueColor,
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: LocaleKeys.auth_confirm.tr(),
                                  size: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 55.h,
                              width: 175.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10.r,
                                ),
                                color: kLightLightSkyBlueColor,
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: LocaleKeys.common_cancel.tr(),
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const LoadingWidget(),
      ],
    );
  }
}
