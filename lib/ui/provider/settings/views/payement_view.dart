import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soan/Common/back_button.dart';
import 'package:soan/constants.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/provider/p_landing_view.dart';

import '../../../../Common/text_widget.dart';

class PayementView extends StatefulWidget {
  const PayementView({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  State<PayementView> createState() => _PayementViewState();
}

class _PayementViewState extends State<PayementView> {
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueColor,
      resizeToAvoidBottomInset: true,
      body: Column(
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
                  text: LocaleKeys.titles_dues.tr(),
                  size: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              //height: 798.h,
              //padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(31.r),
                    topRight: Radius.circular(31.r)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(31.r),
                    topRight: Radius.circular(31.r)),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                  initialOptions: options,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) => log(url.toString()),
                  onLoadStop: (controller, url) async {
                    if (url != null) {
                      if (url.toString().contains(
                          "http://soun.tufahatin-sa.com/api/callback?paymentId=")) {
                        try {
                          await controller
                              .evaluateJavascript(
                            source: "document.documentElement.innerText",
                          )
                              .then((value) {
                            var result = jsonDecode(value);
                            log(result.toString());
                            if (result['status'] == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: kBlueColor,
                                  content: Text(
                                    result['message'],
                                  ),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const PlandingView(
                                          selectedIndex: 3,
                                        ))),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    result['message'],
                                  ),
                                ),
                              );
                            }
                          });
                        } on FormatException catch (e) {
                          log(e.message);
                        }
                      }
                    }
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  onLoadError: (controller, url, code, message) {
                    log(message);
                  },
                  onReceivedServerTrustAuthRequest:
                      (controller, challenge) async {
                    log(challenge.toString());
                    return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
