import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/notification_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/notification_item_widget.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationModel> _notifications = [];
  bool isLoading = true;

  Future getNotifications() async {
    await CostumerController.getNotifications(
      language: window.locale.languageCode,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
    ).then((value) {
      _notifications = value;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getNotifications().then((value) {
        setState(() {
          isLoading = false;
        });
      });
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
                  Align(
                    alignment: context.locale.languageCode == 'en'
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: const BackButtonWidget(),
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
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
