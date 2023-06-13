// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/global_controller.dart';
import 'package:html/parser.dart';

class ContentPageView extends StatefulWidget {
  const ContentPageView({Key? key, required this.name, required this.id})
      : super(key: key);
  final String name;
  final String id;

  @override
  State<ContentPageView> createState() => _ContentPageViewState();
}

class _ContentPageViewState extends State<ContentPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            height: 120.h,
            child: Stack(children: [
              Align(
                alignment: context.locale.languageCode == 'en'
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                child: const BackButtonWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextWidget(
                  text: widget.name,
                  size: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19.r),
                  topRight: Radius.circular(19.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  TextWidget(
                    text: widget.name,
                    size: 20,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: GlobalController.getContentInfo(
                        context.locale.languageCode,
                        widget.id,
                      ),
                      initialData: '',
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        var text = parse(snapshot.data);
                        return snapshot.data.isNotEmpty
                            ? SingleChildScrollView(
                                child: Text(
                                  text.body!.innerHtml,
                                  style: GoogleFonts.tajawal(
                                      fontSize: 22.sp, color: kDarkBleuColor),
                                ),
                              )
                            : SizedBox(
                                height: 800.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
