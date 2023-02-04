import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/models/global/answer_list_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helpers/user_provider.dart';
import '../components/answer_widget.dart';

class ProvidersServicesView extends StatefulWidget {
  const ProvidersServicesView({Key? key, required this.orderId})
      : super(key: key);
  final String orderId;

  @override
  State<ProvidersServicesView> createState() => _ProvidersServicesViewState();
}

class _ProvidersServicesViewState extends State<ProvidersServicesView> {
  bool isNear = true;
  bool isLoading = true;
  List<AnswerListModel> answers = [];

  Future getAnswers() async {
    await CostumerController.getAnswers(
      language: context.locale.languageCode,
      token: Provider.of<UserProvider>(context, listen: false).user.apiToken,
      id: widget.orderId,
    ).then((value) {
      isLoading = false;
      answers = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getAnswers();
    });
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
                      text: LocaleKeys.titles_providers_offers.tr(),
                      size: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: answers.length,
                          itemBuilder: (BuildContext context, int index) {
                            AnswerListModel answer = answers[index];
                            return AnswerWidget(
                              answer: answer,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isLoading) const LoadingWidget(),
        ],
      ),
    );
  }
}
