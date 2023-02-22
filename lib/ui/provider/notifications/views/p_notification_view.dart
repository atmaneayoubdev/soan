import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/constumer/notification_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/notifications/components/notification_item_widget.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        language: window.locale.languageCode,
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
    Future.delayed(Duration.zero, () {
      getNotifications().then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

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
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _notifications.isEmpty
                            ? Center(
                                child: Text(
                                  LocaleKeys.common_no_notificatoins.tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tajawal(
                                    color: kDarkBleuColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _notifications.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 5.h,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  NotificationModel notif =
                                      _notifications[index];
                                  return NotificationItemWidget(notif: notif);
                                },
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
