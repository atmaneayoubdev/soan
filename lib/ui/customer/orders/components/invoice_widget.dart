import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/models/global/inoice_item_model.dart';
import 'package:soan/models/global/invoice_model.dart';
import 'package:soan/translations/locale_keys.g.dart';

import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../helpers/invoice_service_ar.dart';
import '../../../../helpers/invoice_service_en.dart';
import '../../../../helpers/user_provider.dart';

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({
    Key? key,
    required this.orderId,
    required this.order,
  }) : super(key: key);
  final String orderId;
  final OrderModel order;

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  bool isLoading = true;
  InvoiceModel? invoice;

  Future getInvoice() async {
    await CostumerController.getInvoice(
      language: context.locale.languageCode,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      id: widget.orderId,
    ).then((value) {
      isLoading = false;
      setState(() {});
      if (value.runtimeType == InvoiceModel) {
        invoice = value;
        DateTime date = DateTime.parse(invoice!.createdAt);
        invoice!.createdAt = DateFormat('MM/dd/yyyy').format(date);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(19.r),
            topRight: Radius.circular(19.r),
          ),
        ),
        child: isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19.r),
                    topRight: Radius.circular(19.r),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: kBlueColor,
                  ),
                ),
              )
            : Column(
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
                                text: LocaleKeys.costumer_my_orders_invoice_date
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
                          text: invoice!.createdAt,
                          size: 18,
                          color: kDarkBleuColor,
                          fontWeight: FontWeight.normal,
                        )
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
                                text: "(${widget.order.provider!.city.name})",
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
                                    "${widget.order.costumer.firstName} ${widget.order.costumer.firstName}",
                                size: 14,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.normal),
                            TextWidget(
                              text: "(${widget.order.location.city.name})",
                              size: 14,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    height: 230.h,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.order.invoiceItems.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 5.h,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        InvoiceItemModel item =
                            widget.order.invoiceItems[index];
                        return SizedBox(
                          width: 366.w,
                          height: 40.h,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text: item.name,
                                    size: 14,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal),
                                TextWidget(
                                  text:
                                      "${item.price} ${LocaleKeys.common_sar.tr()}",
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                )
                              ],
                            ),
                            const Divider(),
                          ]),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text: LocaleKeys
                                        .costumer_my_orders_service_total_cost
                                        .tr(),
                                    size: 16,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w600),
                                TextWidget(
                                    text:
                                        " ${invoice!.prices.subTotal} ${LocaleKeys.common_sar.tr()}",
                                    size: 16,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w600)
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
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.w600),
                                TextWidget(
                                  text:
                                      "${invoice!.prices.vat} ${LocaleKeys.common_sar.tr()}",
                                  size: 16,
                                  color: kDarkBleuColor,
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
                                horizontal: 20.w, vertical: 20.h),
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
                                    fontWeight: FontWeight.w600),
                                TextWidget(
                                    text:
                                        "${invoice!.prices.total} ${LocaleKeys.common_sar.tr()}",
                                    size: 16,
                                    color: kDarkBleuColor,
                                    fontWeight: FontWeight.normal)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (context.locale.languageCode == 'ar') {
                                final pdfFile =
                                    await PdfInvoiceServiceAr.generate(
                                        invoice!);
                                PdfInvoiceServiceAr.openFile(pdfFile);
                              } else {
                                final pdfFile =
                                    await PdfInvoiceServiceEn.generate(
                                        invoice!);
                                PdfInvoiceServiceEn.openFile(pdfFile);
                              }
                            },
                            child: LargeButton(
                              text: LocaleKeys.costumer_my_orders_download_pdf
                                  .tr(),
                              isButton: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
