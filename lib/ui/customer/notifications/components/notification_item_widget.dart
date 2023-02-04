import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../models/constumer/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    super.key,
    required this.notif,
  });

  final NotificationModel notif;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 7.w),
      //height: 79.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: kLightLightSkyBlueColor,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/notifiction_view_icon.png",
            height: 42.h,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Center(
              child: Text(
                notif.message,
                style:
                    GoogleFonts.tajawal(fontSize: 11.sp, color: kDarkBleuColor),
              ),
            ),
          ),
          //const Spacer(),
          SizedBox(
            width: 10.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset("assets/icons/clock.svg"),
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
  }
}
