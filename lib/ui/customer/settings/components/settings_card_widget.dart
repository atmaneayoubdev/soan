// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../helpers/user_provider.dart';

class SettingsCardWidget extends StatelessWidget {
  const SettingsCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 202.h,
      width: 385.w,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 95.h,
            width: 95.w,
            decoration: const BoxDecoration(
              color: kLightLightGreyColor,
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(300),
              child: CachedNetworkImage(
                imageUrl: Provider.of<UserProvider>(context, listen: true)
                    .user
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
          SizedBox(
            height: 20.w,
          ),
          TextWidget(
            text:
                "${Provider.of<UserProvider>(context, listen: true).user.firstName}  ${Provider.of<UserProvider>(context, listen: true).user.lastName}",
            size: 18,
            color: kDarkBleuColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
