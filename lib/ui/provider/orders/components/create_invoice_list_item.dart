import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';

class CreateInvoiceListItem extends StatelessWidget {
  const CreateInvoiceListItem({
    super.key,
    required this.name,
    required this.price,
    required this.onDelete,
    required this.canEdit,
  });
  final String name;
  final String price;
  final Function onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 366.w,
      //height: 40.h,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                //height: 40.h,
                decoration: BoxDecoration(
                  color: kLightLightGreyColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    name,
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: kDarkBleuColor,
                    ),
                  ),
                ),
              ),
            ),
            2.horizontalSpace,
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                //height: 40.h,
                decoration: BoxDecoration(
                    color: kLightLightGreyColor,
                    borderRadius: BorderRadius.circular(6.r)),
                //width: 101.w,
                child: Align(
                  alignment: Alignment.center,
                  child: TextWidget(
                      text: price,
                      size: 14,
                      color: kDarkBleuColor,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            2.horizontalSpace,
            if (canEdit)
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    onDelete();
                  },
                  child: const Icon(
                    Icons.clear,
                    color: kPinkColor,
                  ),
                ),
              )
          ],
        ),
      ]),
    );
  }
}
