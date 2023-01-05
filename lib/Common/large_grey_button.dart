import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class LargeGreyButton extends StatefulWidget {
  const LargeGreyButton({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<LargeGreyButton> createState() => _LargeGreyButtonState();
}

class _LargeGreyButtonState extends State<LargeGreyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.r,
        ),
        color: kLightLightBlueColor,
      ),
      child: Center(
        child: Text(
          widget.text,
          style: GoogleFonts.tajawal(
            fontSize: 19.sp,
            fontWeight: FontWeight.normal,
            color: kDarkBleuColor,
          ),
        ),
      ),
    );
  }
}
