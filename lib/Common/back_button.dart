import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white)),
        margin: EdgeInsets.symmetric(horizontal: 26.w),
        child: const Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
      ),
    );
  }
}
