import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/global/answer_list_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'rating_heading_widget.dart';

class AcceptContractWidget extends StatefulWidget {
  const AcceptContractWidget({
    Key? key,
    required this.answer,
  }) : super(key: key);
  final AnswerListModel answer;

  @override
  State<AcceptContractWidget> createState() => _AcceptContractWidgetState();
}

class _AcceptContractWidgetState extends State<AcceptContractWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 560.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19.r),
              topRight: Radius.circular(19.r),
            ),
          ),
          child: Column(
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
              RatingHeaderWidget(
                provdier: widget.answer.provider,
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                child: FittedBox(
                  child: TextWidget(
                    text: LocaleKeys
                        .costumer_home_do_you_want_contract_this_provider
                        .tr(),
                    size: 24,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 9.h,
                    width: 9.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPinkColor,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  TextWidget(
                    text: LocaleKeys
                        .costumer_home_you_will_not_be_able_to_cancel
                        .tr(),
                    size: 16,
                    color: kPinkColor,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              setState(() {});
                              await CostumerController.acceptAnswer(
                                      token: Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user
                                          .apiToken,
                                      orderId: widget.answer.orderId,
                                      answerId: widget.answer.id)
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context, true);
                              });
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
                                  text: LocaleKeys.common_yes.tr(),
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
                                  text: LocaleKeys
                                      .costumer_home_no_find_another_provider
                                      .tr(),
                                  size: 14,
                                  color: kDarkBleuColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isLoading) const LoadingWidget(),
      ],
    );
  }
}
