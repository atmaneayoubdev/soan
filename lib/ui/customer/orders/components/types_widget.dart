import 'package:flutter/material.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypeWidget extends StatelessWidget {
  const TypeWidget({
    Key? key,
    required this.name,
  }) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17.h,
      width: 55.w,
      decoration: BoxDecoration(
        color: kLightLightGreyColor,
        borderRadius: BorderRadius.circular(
          10.r,
        ),
      ),
      child: TextWidget(
        text: name,
        size: 10,
        color: kDarkBleuColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
