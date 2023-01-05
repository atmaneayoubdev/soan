import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class HowToKnowUsWidgt extends StatelessWidget {
  const HowToKnowUsWidgt({
    Key? key,
    required this.name,
    required this.isActive,
    required this.isError,
  }) : super(key: key);

  final String name;
  final bool isActive;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: 123.w,
      height: 60.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: isActive ? kBlueColor : kLightLightGreyColor,
          border: Border.all(
            color: isError ? Colors.red : Colors.transparent,
          )),
      child: Center(
        child: Text(
          name,
          style: GoogleFonts.cairo(
            fontSize: 15,
            color: isActive ? Colors.white : kDarkBleuColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
