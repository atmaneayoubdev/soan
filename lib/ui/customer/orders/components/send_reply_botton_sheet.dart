import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';

class SendReplyBottomSheet extends StatefulWidget {
  const SendReplyBottomSheet({super.key, required this.orderId});
  final String orderId;

  @override
  State<SendReplyBottomSheet> createState() => _SendReplyBottomSheetState();
}

class _SendReplyBottomSheetState extends State<SendReplyBottomSheet> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      height: 600.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: kLightLightGreyColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60.r),
                  bottomRight: Radius.circular(60.r),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 5.h,
                width: 50.w,
                decoration: BoxDecoration(
                  color: kGreyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19.r),
                    topRight: Radius.circular(19.r),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              TextWidget(
                  text: LocaleKeys.provider_home_write_message_to_client.tr(),
                  size: 24,
                  color: kDarkBleuColor,
                  fontWeight: FontWeight.normal),
              SizedBox(
                height: 60.h,
              ),
              Container(
                height: 224.h,
                width: 347.w,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: kLightLightGreyColor,
                    )
                  ],
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              SizedBox(
                  height: 52.h,
                  width: 336.w,
                  child: GestureDetector(
                    onTap: () async {
                      isLoading = true;
                      setState(() {});
                      await ProviderController.makeOrderAnswer(
                        language: context.locale.languageCode,
                        token: Provider.of<ProviderProvider>(context,
                                listen: false)
                            .providerModel
                            .apiToken,
                        orderId: widget.orderId,
                        message: controller.text,
                      ).then((value) {
                        isLoading = false;
                        setState(() {});
                        if (value == "Thanks For Answer") {
                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 3),
                              backgroundColor: kBlueColor,
                              content: Text(
                                value.toString(),
                              ),
                            ),
                          );
                        } else {
                          controller.clear();
                          Navigator.pop(context, false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 3),
                              backgroundColor: Colors.red,
                              content: Text(
                                value.toString(),
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: LargeButton(
                        text: LocaleKeys.costumer_home_send.tr(),
                        isButton: true),
                  )),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                    height: 52.h,
                    width: 336.w,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kDarkBleuColor,
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: LocaleKeys.common_cancel.tr(),
                          size: 18,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )),
              ),
            ],
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
