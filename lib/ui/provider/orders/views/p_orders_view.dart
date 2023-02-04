import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/orders/components/p_old_orders_widget.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../controllers/provider_controller.dart';
import '../../../../helpers/provider.provider.dart';
import '../../../../models/provider/p_order_model.dart';
import '../components/p_current_orders_widget.dart';
import '../../../../Common/title_widget.dart';

class PordersView extends StatefulWidget {
  const PordersView({Key? key}) : super(key: key);

  @override
  State<PordersView> createState() => _PordersViewState();
}

class _PordersViewState extends State<PordersView> {
  int selectedPage = 0;
  bool isLoading = true;
  final List<PorderModel> _ordersList = [];
  Future getOrders(String status) async {
    if (mounted) {
      isLoading = true;
    }
    setState(() {});
    await ProviderController.getOrdersList(
      language: context.locale.languageCode,
      token: Provider.of<ProviderProvider>(context, listen: false)
          .providerModel
          .apiToken,
      status: status,
    ).then(
      (value) {
        _ordersList.addAll(value);
        isLoading = false;
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        getOrders('process').then((value) {
          if (mounted) {
            getOrders('wait_for_pay');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset("assets/images/home_back.png"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 63.h,
            ),
            TitleWidget(
              title: LocaleKeys.titles_orders.tr(),
              isProvider: true,
            ),
            Expanded(
              child: Container(
                width: 385.w,
                margin: EdgeInsets.only(
                  top: 20.h,
                  left: 22.w,
                  right: 22.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 13.w,
                  vertical: 13.h,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 3),
                        spreadRadius: 5,
                        blurRadius: 2,
                        color: kLightLightGreyColor,
                      )
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedPage != 0 && !isLoading) {
                                _ordersList.clear();
                                selectedPage = 0;
                                setState(() {});
                                getOrders('process').then((value) {
                                  getOrders('wait_for_pay');
                                });
                              }
                            },
                            child: SizedBox(
                              // width: 156.w,
                              child: TextWidget(
                                text: LocaleKeys
                                    .costumer_my_orders_current_orders
                                    .tr(),
                                size: 14,
                                color: selectedPage == 0
                                    ? kDarkBleuColor
                                    : kLightDarkBleuColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 10.h,
                          width: 2.w,
                          color: kLightLightBlueColor,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedPage != 1 && !isLoading) {
                                _ordersList.clear();
                                selectedPage = 1;
                                setState(() {});
                                getOrders('done').then((value) {
                                  getOrders('cancel');
                                });
                              }
                            },
                            child: SizedBox(
                              //width: 156.w,
                              child: TextWidget(
                                text: LocaleKeys
                                    .costumer_my_orders_finished_orders
                                    .tr(),
                                size: 14,
                                color: selectedPage == 1
                                    ? kDarkBleuColor
                                    : kLightDarkBleuColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: SizedBox(
                        height: 2.h,
                        width: 384.w,
                        child: Stack(
                          children: [
                            Container(
                              height: 1.h,
                              width: 384.w,
                              color: kLightLightGreyColor,
                            ),
                            context.locale.languageCode == 'en'
                                ? Align(
                                    alignment: selectedPage == 0
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Container(
                                      height: 1.h,
                                      width: 340.w / 2,
                                      color: kDarkBleuColor,
                                    ),
                                  )
                                : Align(
                                    alignment: selectedPage == 0
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      height: 1.h,
                                      width: 340.w / 2,
                                      color: kDarkBleuColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),

                    //////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////////
                    Expanded(
                      child: _ordersList.isNotEmpty
                          ? ListView.separated(
                              itemCount: _ordersList.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 20.h,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                PorderModel order = _ordersList[index];
                                return order.orderStatus == "done" ||
                                        order.orderStatus == "cancel"
                                    ? PoldOrdersWidget(order: order)
                                    : PcurrentOrdersWidget(
                                        order: order,
                                      );
                              },
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/home_add_image.png',
                                  height: 82.h,
                                  width: 140.w,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                TextWidget(
                                  text: LocaleKeys
                                      .costumer_my_orders_no_orders_now
                                      .tr(),
                                  size: 18,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                )
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isLoading) const LoadingWidget(),
      ]),
    );
  }
}
