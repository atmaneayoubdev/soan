import 'package:flutter/material.dart';
import 'package:soan/ui/provider/notifications/views/p_notification_view.dart';
import 'text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';
import '../ui/customer/notifications/views/notification_view.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.title,
    required this.isProvider,
  }) : super(key: key);
  final String title;
  final bool isProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 27.w),
      child: Stack(
        children: [
          Center(
            child: TextWidget(
                text: title,
                size: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => isProvider
                          ? const PnotificationView(isBack: true)
                          : const NotificationView()),
                );
              },
              child: Container(
                height: 37.h,
                width: 37.2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kLightLightGreyColor,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/home_notification.svg",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
