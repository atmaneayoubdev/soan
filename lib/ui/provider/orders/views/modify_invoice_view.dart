import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/loading_widget.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;
import '../../../../controllers/global_controller.dart';
import '../../../../controllers/provider_controller.dart';
import '../../../../helpers/provider.provider.dart';
import '../../../../models/global/inoice_item_model.dart';
import '../../../../models/global/invoice_model.dart';
import '../../../../models/global/settings_model.dart';
import '../../../../models/provider/p_order_model.dart';
import '../../p_landing_view.dart';
import '../components/create_invoice_list_item.dart';
import '../components/invoice_add_item_borrom_sheet.dart';
import '../components/invoice_sent_bottom_sheet.dart';

class ModifyInvoiceView extends StatefulWidget {
  const ModifyInvoiceView({Key? key, required this.order}) : super(key: key);
  final PorderModel order;

  @override
  State<ModifyInvoiceView> createState() => _ModifyInvoiceViewState();
}

class _ModifyInvoiceViewState extends State<ModifyInvoiceView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<InvoiceItemModel> items = [];
  double subTotal = 0;
  double vat = 0;
  double totalVat = 0;
  double total = 0;
  bool isLoading = false;

  InvoiceModel? invoice;

  Future getInvoice() async {
    await ProviderController.getInvoice(
      language: context.locale.languageCode,
      token: Provider.of<ProviderProvider>(context, listen: false)
          .providerModel
          .apiToken,
      id: widget.order.id,
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

  Future getSettings() async {
    if (mounted) {
      await GlobalController.getSettings(context.locale.languageCode)
          .then((value) {
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
    Future.delayed(Duration.zero, () {
      getSettings();
      getInvoice();

      items = widget.order.invoiceItems;
      subTotal = double.parse(widget.order.price.subTotal);
      totalVat = double.parse(widget.order.price.vat);
      total = double.parse(widget.order.price.total);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: kBlueColor,
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
                      text: LocaleKeys.titles_invoice.tr(),
                      size: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                          text: LocaleKeys
                                              .costumer_my_orders_invoice_date
                                              .tr(),
                                          size: 18,
                                          color: kGreyColor,
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
                                      text: invoice == null
                                          ? ''
                                          : invoice!.createdAt,
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
                                    text:
                                        LocaleKeys.costumer_my_orders_from.tr(),
                                    size: 14,
                                    color: kGreyColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                          text: widget
                                              .order.provider!.providerName,
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
                                      color: kGreyColor,
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
                                    color: kGreyColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                          text:
                                              '${widget.order.costumer.lastName} ${widget.order.costumer.firstName}',
                                          size: 14,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.normal),
                                      TextWidget(
                                          text:
                                              widget.order.location.region.name,
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
                              height: 40.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      width: 286.w,
                                      child: TextWidget(
                                          text: LocaleKeys
                                              .provider_orders_description
                                              .tr(),
                                          size: 12,
                                          color: kGreyColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      width: 101.w,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: TextWidget(
                                            text:
                                                "${LocaleKeys.provider_orders_price.tr()} (${LocaleKeys.common_sar.tr()}) ",
                                            size: 12,
                                            color: kGreyColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  const Expanded(flex: 1, child: SizedBox()),
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
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 5.h,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return CreateInvoiceListItem(
                                    canEdit: widget.order.orderStatus !=
                                            "done" &&
                                        widget.order.orderStatus != "cancel",
                                    onDelete: () {
                                      items.removeAt(index);
                                      setState(() {});
                                    },
                                    price: items[index].price.toString(),
                                    name: items[index].name,
                                  );
                                },
                              ),
                            ),
                            // Spacer(),

                            10.verticalSpace,
                            if (widget.order.orderStatus != "done" &&
                                widget.order.orderStatus != "cancel")
                              GestureDetector(
                                onTap: () {
                                  modal
                                      .showMaterialModalBottomSheet(
                                    enableDrag: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        InvoiceAddItemBottomSheet(
                                      nameController: nameController,
                                      valueController: valueController,
                                    ),
                                  )
                                      .then((value) {
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
                                          subTotal += double.parse(
                                              valueController.text);
                                          totalVat = (vat * subTotal) / 100;
                                          total = subTotal + totalVat;
                                        });
                                        valueController.clear();
                                        nameController.clear();
                                        scrollController.animateTo(
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            scrollController
                                                .position.maxScrollExtent,
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
                                        text: LocaleKeys
                                            .provider_orders_add_other_item
                                            .tr(),
                                        size: 16,
                                        color: kGreenColor,
                                        fontWeight: FontWeight.normal),
                                  ],
                                ),
                              ),
                            10.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25.w),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, -5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      color: kLightLightGreyColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          text:
                                              "$subTotal ${LocaleKeys.common_sar.tr()} ",
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          text:
                                              "$totalVat ${LocaleKeys.common_sar.tr()}",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          text: LocaleKeys.common_total.tr(),
                                          size: 16,
                                          color: kDarkBleuColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        TextWidget(
                                          text:
                                              "$total ${LocaleKeys.common_sar.tr()}",
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
                                  if (widget.order.orderStatus != "done" &&
                                      widget.order.orderStatus != "cancel")
                                    GestureDetector(
                                      onTap: () async {
                                        isLoading = true;
                                        setState(() {});
                                        await ProviderController.addUpdateBill(
                                          language: context.locale.languageCode,
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
                                          if (value == "بيانات الطلب" ||
                                              value == 'Order Information') {
                                            modal
                                                .showMaterialModalBottomSheet(
                                              enableDrag: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                                  const SentInvoiceBottomSheet(),
                                            )
                                                .then((value) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PlandingView(
                                                    selectedIndex: 1,
                                                  ),
                                                ),
                                                (route) => false,
                                              );
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration:
                                                    const Duration(seconds: 3),
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
                                        text:
                                            LocaleKeys.costumer_home_send.tr(),
                                        isButton: false,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
