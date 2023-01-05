import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';

class CancelOrderReason extends StatefulWidget {
  const CancelOrderReason({
    Key? key,
    required this.name,
    required this.isSelected,
  }) : super(key: key);

  final String name;
  final bool isSelected;

  @override
  State<CancelOrderReason> createState() => _CancelOrderReasonState();
}

class _CancelOrderReasonState extends State<CancelOrderReason> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      //width: 115.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: kBlueColor,
        ),
        color: widget.isSelected ? kBlueColor : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: TextWidget(
          text: widget.name,
          size: 12,
          color: widget.isSelected ? Colors.white : kDarkBleuColor,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
