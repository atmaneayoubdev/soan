import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/invoice_widget.dart';
import 'rating_view.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  OrderModel? orderModel;
  int? page;
  bool isLoading = true;

  Future getOrder() async {
    isLoading = true;
    setState(() {});
    await CostumerController.getOrder(
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      id: widget.orderId,
    ).then((value) {
      isLoading = false;
      if (value.runtimeType == OrderModel) {
        orderModel = value;
        if (orderModel!.costumerRate == "false") {
          page = 1;
        }
        if (orderModel!.costumerRate == 'true') {
          if (orderModel!.invoiceItems.isEmpty) {
            page = 0;
          }
          if (orderModel!.invoiceItems.isNotEmpty) {
            page = 2;
          }
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Stack(
        children: [
          Column(
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
                      text: LocaleKeys.titles_invoice.tr(),
                      size: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              page == 0 && isLoading == false
                  ? Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(19.r),
                            topRight: Radius.circular(19.r),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/noInvoice.png',
                              width: 250.w,
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            TextWidget(
                              text: LocaleKeys
                                  .costumer_my_orders_invoice_not_issued_yet
                                  .tr(),
                              size: 20,
                              color: kDarkBleuColor,
                              fontWeight: FontWeight.normal,
                            )
                          ],
                        ),
                      ),
                    )
                  : page == 1 && isLoading == false
                      ? Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.r),
                                topRight: Radius.circular(19.r),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/rateImage.png',
                                  width: 302.w,
                                ),
                                SizedBox(
                                  height: 120.h,
                                ),
                                TextWidget(
                                  text: LocaleKeys
                                      .costumer_my_orders_rate_the_provider_first
                                      .tr(),
                                  size: 16,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                TextWidget(
                                  text: LocaleKeys
                                      .costumer_my_orders_invoice_not_issued_yet
                                      .tr(),
                                  size: 16,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                SizedBox(
                                  height: 100.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) => RatingView(
                                              order: orderModel!,
                                            )),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        getOrder().then((value) {
                                          if (orderModel!.costumerRate ==
                                              "false") {
                                            page = 1;
                                          }
                                          if (orderModel!.costumerRate ==
                                              'true') {
                                            if (orderModel!
                                                .invoiceItems.isEmpty) {
                                              page = 0;
                                            }
                                            if (orderModel!
                                                .invoiceItems.isNotEmpty) {
                                              page = 2;
                                            }
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 45.w),
                                      child: LargeButton(
                                          text: LocaleKeys
                                              .costumer_my_orders_rate
                                              .tr(),
                                          isButton: true)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : page == 2 && isLoading == false
                          ? InvoiceWidget(
                              order: orderModel!,
                              orderId: orderModel!.id,
                            )
                          : Expanded(
                              child: Container(
                                width: double.infinity,
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
                              ),
                            ),
            ],
          ),
        ],
      ),
    );
  }
}
