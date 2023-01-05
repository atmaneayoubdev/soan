import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/large_button.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConnectionView extends StatefulWidget {
  const NoConnectionView({Key? key}) : super(key: key);

  @override
  State<NoConnectionView> createState() => _NoConnectionViewState();
}

class _NoConnectionViewState extends State<NoConnectionView> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isLoading = false;
  bool isPassVisible = false;
  bool isPassConfVisible = false;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            height: 120.h,
            child: Stack(children: [
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: BackButtonWidget(),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextWidget(
                  text: LocaleKeys.titles_offline.tr(),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/no_connection.png"),
                  SizedBox(
                    height: 20.h,
                  ),
                  const TextWidget(
                    text: "لا يوجد اتصال بالشبكة",
                    size: 18,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const TextWidget(
                    text: "فشل الاتصال بالشبكة",
                    size: 18,
                    color: kLightDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const TextWidget(
                    text: "يرجي التحقق من اتصالك بالانترنت",
                    size: 18,
                    color: kLightDarkBleuColor,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Phoenix.rebirth(context);
                    },
                    child: const LargeButton(
                        text: "إعادة المحاولة", isButton: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
