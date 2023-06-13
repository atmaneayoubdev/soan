import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/global_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/back_button.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuggestionsView extends StatefulWidget {
  const SuggestionsView({Key? key, required this.isProvider}) : super(key: key);
  final bool isProvider;

  @override
  State<SuggestionsView> createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
                      text: LocaleKeys.titles_suggestions.tr(),
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19.r),
                      topRight: Radius.circular(19.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          TextWidget(
                            text: LocaleKeys
                                .costumer_settings_share_with_us_your_opinion
                                .tr(),
                            size: 20,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          TextWidget(
                            text: LocaleKeys
                                .costumer_settings_to_get_better_service
                                .tr(),
                            size: 20,
                            color: kDarkBleuColor,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          SizedBox(
                            height: 525.h,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.top,
                              textAlign: TextAlign.start,
                              controller: controller,
                              maxLines: null,
                              expands: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.common_enter_suggestion
                                      .tr();
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kLightLightGreyColor,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.r)),
                                  borderSide: const BorderSide(
                                      width: 1, color: kLightGreyColor),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.r)),
                                    borderSide: const BorderSide(
                                      // width: 1,
                                      color: Colors.red,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  isLoading = true;
                                  setState(() {});
                                  await GlobalController.sendMessage(
                                    token: widget.isProvider
                                        ? Provider.of<ProviderProvider>(context,
                                                listen: false)
                                            .providerModel
                                            .apiToken
                                        : Provider.of<UserProvider>(
                                            context,
                                            listen: false,
                                          ).user.apiToken,
                                    message: controller.text,
                                    type: 'feedback',
                                    language: context.locale.languageCode,
                                  ).then((value) {
                                    isLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: value["code"] == "400"
                                            ? Colors.red
                                            : kBlueColor,
                                        content: Text(
                                          value["message"],
                                        ),
                                      ),
                                    );
                                    if (value["code"] == "200") {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                              child: LargeButton(
                                  text: LocaleKeys.costumer_home_send.tr(),
                                  isButton: false)),
                        ],
                      ),
                    ),
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
