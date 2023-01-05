import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/Common/text_widget.dart';
import 'package:soan/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soan/models/constumer/order_model.dart';
import 'package:soan/models/global/refusal_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/landing_view.dart';

import '../../../../controllers/costumer_controller.dart';
import '../../../../controllers/global_controller.dart';
import '../../../../helpers/user_provider.dart';
import 'cancel_order_reason_widget.dart';

class CancleWidget extends StatefulWidget {
  const CancleWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderModel order;

  @override
  State<CancleWidget> createState() => _CancleWidgetState();
}

class _CancleWidgetState extends State<CancleWidget> {
  RefusalModel? _selectedFefusal;
  List<RefusalModel> _refusalList = [];
  bool isLoading = true;

  Future getRefusalList() async {
    await GlobalController.getRefualList().then((value) {
      _refusalList = value;
      value.isNotEmpty
          ? _selectedFefusal = value.first
          : _selectedFefusal = null;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getRefusalList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 540.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Container(
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
              ),
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                "assets/images/cancelImage.png",
                height: 203.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                child: TextWidget(
                  text:
                      LocaleKeys.costumer_my_orders_do_you_want_to_cancel.tr(),
                  size: 24,
                  color: kDarkBleuColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                //height: 66.h,
                width: 366.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: LocaleKeys.costumer_my_orders_cancel_reason.tr(),
                      size: 12,
                      color: kLightDarkBleuColor,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 41.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _refusalList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5.w,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          RefusalModel ref = _refusalList[index];
                          return GestureDetector(
                            onTap: () {
                              if (_selectedFefusal != ref) {
                                _selectedFefusal = ref;
                                setState(() {});
                              }
                            },
                            child: CancelOrderReason(
                              name: ref.name,
                              isSelected:
                                  _selectedFefusal == ref ? true : false,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 360.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context, false),
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
                            text: LocaleKeys.costumer_my_orders_continue_request
                                .tr(),
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
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        await CostumerController.cancelOrder(
                                token: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .apiToken,
                                orderId: widget.order.id,
                                refusalId: _selectedFefusal!.id)
                            .then((value) {
                          isLoading = false;
                          setState(() {});
                          if (value.runtimeType == OrderModel) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LandingView(
                                  selectedIndex: 2,
                                ),
                              ),
                              (route) => false,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kBlueColor,
                                content: Text(
                                  LocaleKeys.costumer_my_orders_order_canceled
                                      .tr(),
                                ),
                              ),
                            );
                          } else {
                            Navigator.pop(context, true);

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
                      child: Container(
                        height: 55.h,
                        width: 175.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.r,
                          ),
                          color: kLightLightPinkColor,
                        ),
                        child: Center(
                          child: TextWidget(
                            text:
                                LocaleKeys.costumer_my_orders_cancel_order.tr(),
                            size: 14,
                            color: kPinkColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
