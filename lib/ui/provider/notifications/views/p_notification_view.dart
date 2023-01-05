import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/constumer/notification_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PnotificationView extends StatefulWidget {
  const PnotificationView({Key? key, required this.isBack}) : super(key: key);
  final bool isBack;

  @override
  State<PnotificationView> createState() => _PnotificationViewState();
}

class _PnotificationViewState extends State<PnotificationView> {
  List<NotificationModel> _notifications = [];
  bool isLoading = true;

  Future getNotifications() async {
    if (mounted) {
      await ProviderController.getNotifications(
        language: 'ar',
        token: Provider.of<ProviderProvider>(context, listen: false)
            .providerModel
            .apiToken,
      ).then((value) {
        _notifications = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
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
                  if (widget.isBack)
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: BackButtonWidget(),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextWidget(
                      text: LocaleKeys.titles_notifications.tr(),
                      size: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                        height: 26.h,
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _notifications.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 5.h,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            NotificationModel notif = _notifications[index];
                            return Container(
                              padding: EdgeInsets.all(10.h),
                              height: 79.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: kLightLightSkyBlueColor,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/notifiction_view_icon.png",
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: TextWidget(
                                      text: notif.message,
                                      size: 11,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  //const Spacer(),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/icons/clock.svg"),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      TextWidget(
                                        text: notif.createdAt,
                                        size: 10,
                                        color: kLightDarkBleuColor,
                                        fontWeight: FontWeight.normal,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
