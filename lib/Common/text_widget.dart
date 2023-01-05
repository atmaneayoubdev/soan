import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    required this.size,
    required this.color,
    required this.fontWeight,
  }) : super(key: key);
  final String text;
  final int size;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: GoogleFonts.tajawal(
        fontSize: size.sp,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
