import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../constants.dart';

// ignore: must_be_immutable
class SlideTile extends StatefulWidget {
  String imagePath, desc;

  SlideTile({Key? key, required this.imagePath, required this.desc})
      : super(key: key);

  @override
  State<SlideTile> createState() => _SlideTileState();
}

class _SlideTileState extends State<SlideTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: kLightLightBlueColor,
            height: 490.h,
            width: double.infinity.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140.h,
                ),
                SizedBox(
                    height: 270.h,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.fill,
                    )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 45.h,
                ),
                Text(
                  LocaleKeys.common_soan.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: kDarkBleuColor,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  //height: 100.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    widget.desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: kBlueColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
