import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/global/settings_model.dart';
import 'package:soan/models/provider/p_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/p_landing_view.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/global_controller.dart';
import '../components/invoice_sent_bottom_sheet.dart';

class MakeInvoiceView extends StatefulWidget {
  const MakeInvoiceView({Key? key, required this.order}) : super(key: key);
  final PorderModel order;

  @override
  State<MakeInvoiceView> createState() => _MakeInvoiceViewState();
}

class _MakeInvoiceViewState extends State<MakeInvoiceView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  List<InvoiceItemModel> items = [];
  double subTotal = 0;
  double vat = 0;
  double totalVat = 0;
  double total = 0;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();

  Future getSettings() async {
    if (mounted) {
      await GlobalController.getSettings().then((value) {
        if (value.runtimeType == SettingsModel) {
          SettingsModel s = value;
          vat = double.parse(s.info.vat);
        }
        isLoading = false;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBlueColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
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
                        text: LocaleKeys.titles_create_invoice.tr(),
                        size: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 5,
                                blurRadius: 2,
                                color: kLightLightGreyColor,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text: LocaleKeys
                                        .costumer_my_orders_invoice_date
                                        .tr(),
                                    size: 18,
                                    color: kLightDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                                TextWidget(
                                    text: "#${widget.order.id}",
                                    size: 18,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal)
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            TextWidget(
                                text: widget.order.createdAt,
                                size: 18,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 5,
                                blurRadius: 2,
                                color: kLightLightGreyColor,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: LocaleKeys.costumer_my_orders_from.tr(),
                              size: 14,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text: widget.order.provider!.providerName,
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                                TextWidget(
                                    text:
                                        "(${widget.order.provider!.region.name})",
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal)
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextWidget(
                                text: LocaleKeys.auth_tax_number.tr(),
                                size: 14,
                                color: kLightDarkBleuColor,
                                fontWeight: FontWeight.normal),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextWidget(
                                text: widget.order.provider!.taxNumber,
                                size: 14,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 5,
                                blurRadius: 2,
                                color: kLightLightGreyColor,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: LocaleKeys.costumer_my_orders_to.tr(),
                              size: 14,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text:
                                        '${widget.order.costumer.lastName} ${widget.order.costumer.firstName}',
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                                TextWidget(
                                    text: widget.order.location.region.name,
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal)
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              height: 40.h,
                              width: 286.w,
                              child: Align(
                                alignment: context.locale.languageCode == 'en'
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: TextWidget(
                                    text: LocaleKeys.provider_orders_description
                                        .tr(),
                                    size: 12,
                                    color: kLightDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              height: 40.h,
                              width: 101.w,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextWidget(
                                    text:
                                        "${LocaleKeys.provider_orders_price.tr()} (${LocaleKeys.common_sar.tr()}) ",
                                    size: 12,
                                    color: kLightDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 5.h),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 5.h,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 366.w,
                              height: 40.h,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: kLightLightGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      width: 286.w,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextWidget(
                                          text: items[index].name,
                                          size: 14,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                          color: kLightLightGreyColor,
                                          borderRadius:
                                              BorderRadius.circular(6.r)),
                                      width: 101.w,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextWidget(
                                            text: items[index].price.toString(),
                                            size: 14,
                                            color: kDarkBleuColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: items.length > 2 ? 20.h : 150.h,
                      ),
                      SizedBox(
                        height: widget.order.orderStatus != "done" &&
                                widget.order.orderStatus != "cancel"
                            ? 280.h
                            : 210.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showMaterialModalBottomSheet(
                      enableDrag: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          height: 180.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(19.r),
                              topRight: Radius.circular(19.r),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                        color: kLightLightGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(6.r)),
                                    width: 286.w,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.tajawal(
                                            fontSize: 16.r,
                                            color: kLightDarkBleuColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          hintText: LocaleKeys
                                              .provider_orders_description
                                              .tr(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                        color: kLightLightGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(6.r)),
                                    width: 101.w,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: valueController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.tajawal(
                                            fontSize: 16.r,
                                            color: kLightDarkBleuColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          hintText:
                                              "${LocaleKeys.provider_orders_price.tr()} (${LocaleKeys.common_sar.tr()}) ",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Container(
                                      height: 55.h,
                                      width: 175.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: kBlueColor,
                                      ),
                                      child: Center(
                                        child: TextWidget(
                                          text: LocaleKeys.auth_confirm.tr(),
                                          size: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Container(
                                      height: 55.h,
                                      width: 175.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: kLightLightSkyBlueColor,
                                      ),
                                      child: Center(
                                        child: TextWidget(
                                          text: LocaleKeys.common_cancel.tr(),
                                          size: 14,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        if (value &&
                            nameController.text.isNotEmpty &&
                            valueController.text.isNotEmpty) {
                          setState(() {
                            items.add(
                              InvoiceItemModel(
                                price: valueController.text,
                                name: nameController.text,
                                id: '',
                              ),
                            );
                            subTotal += double.parse(valueController.text);
                            totalVat = (vat * subTotal) / 100;
                            total = subTotal + totalVat;
                          });
                          valueController.clear();
                          nameController.clear();
                          scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(seconds: 1),
                              curve: Curves.ease);
                        }
                        valueController.clear();
                        nameController.clear();
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outlined,
                        color: kGreenColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      TextWidget(
                          text: LocaleKeys.provider_orders_add_other_item.tr(),
                          size: 16,
                          color: kGreenColor,
                          fontWeight: FontWeight.normal),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  height: widget.order.orderStatus != "done" &&
                          widget.order.orderStatus != "cancel"
                      ? 260.h
                      : 210.h,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      color: kLightLightSkyBlueColor,
                    )
                  ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: LocaleKeys
                                  .costumer_my_orders_service_total_cost
                                  .tr(),
                              size: 16,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.w600,
                            ),
                            TextWidget(
                              text: "$subTotal ${LocaleKeys.common_sar.tr()} ",
                              size: 16,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: LocaleKeys
                                  .costumer_my_orders_total_added_cost
                                  .tr(),
                              size: 16,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.w600,
                            ),
                            TextWidget(
                              text: "$totalVat ${LocaleKeys.common_sar.tr()}",
                              size: 16,
                              color: kLightDarkBleuColor,
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: kLightLightSkyBlueColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: LocaleKeys.common_total.tr(),
                              size: 16,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.w600,
                            ),
                            TextWidget(
                              text: "$total ${LocaleKeys.common_sar.tr()}",
                              size: 16,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          isLoading = true;
                          setState(() {});
                          await ProviderController.addUpdateBill(
                            token: Provider.of<ProviderProvider>(
                              context,
                              listen: false,
                            ).providerModel.apiToken,
                            orderId: widget.order.id,
                            items: items,
                            subTotal: subTotal,
                            vat: totalVat,
                            total: total,
                          ).then((value) {
                            isLoading = false;
                            setState(() {});
                            if (value == "بيانات الطلب") {
                              showMaterialModalBottomSheet(
                                enableDrag: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) =>
                                    const SentInvoiceBottomSheet(),
                              ).then((value) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PlandingView(
                                      selectedIndex: 1,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    value,
                                  ),
                                ),
                              );
                            }
                          });
                        },
                        child: LargeButton(
                          text: LocaleKeys.costumer_home_send.tr(),
                          isButton: false,
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}