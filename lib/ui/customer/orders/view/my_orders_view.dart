import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../Common/title_widget.dart';
import '../components/current_order_widget.dart';
import '../components/old_order_widger.dart';
import '../components/pending_order_widget.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  int selectedPage = 0;
  bool isLoading = true;
  bool isPendingTrue = false;

  final List<OrderModel> _ordersList = [];
  Future getOrders(String status) async {
    //_ordersList.clear();

    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    await CostumerController.getOrdersList(
            token:
                Provider.of<UserProvider>(context, listen: false).user.apiToken,
            status: status)
        .then((value) {
      _ordersList.addAll(value);
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getOrders('process').then((value) {
        if (mounted) {
          getOrders('wait_for_pay');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              title: LocaleKeys.titles_my_orders.tr(),
              isProvider: false,
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
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
                            GestureDetector(
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
                            Container(
                              height: 10.h,
                              width: 2.w,
                              color: kLightLightBlueColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (selectedPage != 1 && !isLoading) {
                                  _ordersList.clear();
                                  selectedPage = 1;
                                  setState(() {});
                                  getOrders('new');
                                }
                              },
                              child: SizedBox(
                                //width: 156.w,
                                child: TextWidget(
                                  text: LocaleKeys
                                      .costumer_my_orders_pending_orders
                                      .tr(),
                                  size: 14,
                                  color: selectedPage == 1
                                      ? kDarkBleuColor
                                      : kLightDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              height: 10.h,
                              width: 2.w,
                              color: kLightLightBlueColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (selectedPage != 2 && !isLoading) {
                                  _ordersList.clear();
                                  selectedPage = 2;
                                  setState(() {});
                                  getOrders('done');
                                  // .then((value) {
                                  //   getOrders('cancel');
                                  // });
                                }
                              },
                              child: SizedBox(
                                //width: 156.w,
                                child: TextWidget(
                                  text: LocaleKeys
                                      .costumer_my_orders_finished_orders
                                      .tr(),
                                  size: 14,
                                  color: selectedPage == 2
                                      ? kDarkBleuColor
                                      : kLightDarkBleuColor,
                                  fontWeight: FontWeight.normal,
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
                                            : selectedPage == 1
                                                ? Alignment.center
                                                : Alignment.centerRight,
                                        child: Container(
                                          height: 1.h,
                                          width: 384.w / 3,
                                          color: kDarkBleuColor,
                                        ),
                                      )
                                    : Align(
                                        alignment: selectedPage == 0
                                            ? Alignment.centerRight
                                            : selectedPage == 1
                                                ? Alignment.center
                                                : Alignment.centerLeft,
                                        child: Container(
                                          height: 1.h,
                                          width: 384.w / 3,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    OrderModel order = _ordersList[index];
                                    return selectedPage == 0
                                        ? CurrentOrderWidget(
                                            order: order,
                                          )
                                        : selectedPage == 1
                                            ? PendingOrderWidget(
                                                order: order,
                                                onOrderUpdated: () {
                                                  getOrders("new");
                                                },
                                              )
                                            : selectedPage == 2
                                                ? OldOrderWidget(
                                                    order: order,
                                                  )
                                                : const SizedBox();
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
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const Center(
                        child: CircularProgressIndicator(
                      color: kBlueColor,
                    )),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
