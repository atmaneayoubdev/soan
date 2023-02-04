import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/provider/dues_model.dart';
import 'package:soan/models/provider/dues_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/settings/views/payement_view.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/bill_widget.dart';

class DuesView extends StatefulWidget {
  const DuesView({Key? key}) : super(key: key);

  @override
  State<DuesView> createState() => _DuesViewState();
}

class _DuesViewState extends State<DuesView> {
  DuesModel? dues;
  bool isLoading = true;

  Future getDues() async {
    await ProviderController.getDuesOrders(
      Provider.of<ProviderProvider>(context, listen: false)
          .providerModel
          .apiToken,
      context.locale.languageCode,
    ).then((value) {
      if (value.runtimeType == DuesModel) {
        dues = value;
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getDues();
    });
  }

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
                  text: LocaleKeys.titles_dues.tr(),
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
          isLoading
              ? Expanded(
                  child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kBlueColor,
                    ),
                  ),
                ))
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 21.h,
                        ),
                        Container(
                          height: 169.h,
                          width: 396.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: kLightLightGreyColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                text: LocaleKeys.titles_dues.tr(),
                                size: 22,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              TextWidget(
                                text: " ${dues!.dues} "
                                    "${LocaleKeys.common_sar.tr()}",
                                size: 22,
                                color: kPinkColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: dues!.orders.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10.h,
                              );
                            },
                            itemBuilder: (BuildContext context, int index) {
                              DuesOrderModel order = dues!.orders[index];
                              return BillWidget(
                                order: order,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              if (dues != null && dues!.orders.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    isLoading = true;
                                    setState(() {});
                                    await ProviderController.makeDues(
                                      language: context.locale.languageCode,
                                      token: Provider.of<ProviderProvider>(
                                              context,
                                              listen: false)
                                          .providerModel
                                          .apiToken,
                                    ).then((value) {
                                      isLoading = false;
                                      setState(() {});

                                      if (value != "error") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                PayementView(url: value)),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  child: LargeButton(
                                      text: LocaleKeys
                                          .provider_settings_pay_dues
                                          .tr(),
                                      isButton: false),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (dues != null && dues!.orders.isEmpty)
                                Container(
                                  width: double.maxFinite,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
                                    border: Border.all(color: kBlueColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys
                                          .provider_settings_dues_completed
                                          .tr(),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                        color: kDarkBleuColor,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
