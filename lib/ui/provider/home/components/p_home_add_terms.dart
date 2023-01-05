import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../views/add_terms_view.dart';

class PhomeAddTerms extends StatelessWidget {
  const PhomeAddTerms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 682.h,
        width: 385.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 5,
                color: kLightLightGreyColor,
              )
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
            ),
            Image.asset(
              "assets/images/add_terms_conditions.png",
              height: 191.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            const TextWidget(
              text: "اضف سياسة وشروط المركز",
              size: 16,
              color: kDarkBleuColor,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
                width: 328.h,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const AddTermsAndConditions())));
                    },
                    child: const LargeButton(text: "إضافة", isButton: false)))
          ],
        ),
      ),
    );
  }
}
