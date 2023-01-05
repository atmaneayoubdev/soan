import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class LargeButton extends StatefulWidget {
  const LargeButton({
    Key? key,
    required this.text,
    required this.isButton,
  }) : super(key: key);
  final String text;
  final bool isButton;

  @override
  State<LargeButton> createState() => _LargeButtonState();
}

class _LargeButtonState extends State<LargeButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.maxFinite,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10.r,
            ),
            color: kBlueColor,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: GoogleFonts.tajawal(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (widget.isButton)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                "assets/icons/forword_button.png",
                height: 40.h,
              ),
            ),
          ),
      ],
    );
  }
}
