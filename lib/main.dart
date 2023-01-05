import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/Common/no_connection_view.dart';
import 'package:soan/helpers/car_provider.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/translations/codegen_loader.g.dart';
import 'package:soan/ui/Introduction/views/introduction_view.dart';
import 'package:soan/ui/provider/p_landing_view.dart';
import 'constants.dart';
import 'helpers/user_provider.dart';
import 'models/global/city_model.dart';
import 'models/global/how_to_know_us_model.dart';
import 'models/global/region_model.dart';
import 'ui/Authentication/views/signin_view.dart';
import 'ui/Authentication/views/signup_type_view.dart';
import 'ui/Authentication/views/user_first_signup_view.dart';
import 'ui/customer/landing_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    /// 1. Wrap your App widget in the Phoenix widget
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      assetLoader: const CodegenLoader(),
      //startLocale: const Locale('ar'),
      child: Phoenix(
        child: const MyApp(),
      ),
    ),
  );

  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserModel _userModel = UserModel(
    firstName: '',
    lastName: '',
    phoneNumber: '',
    apiToken: '',
    avatar: '',
    email: '',
  );

  ProviderModel _provider = ProviderModel(
    id: '',
    providerName: '',
    phone: '',
    commercialRegistrationNumber: '',
    taxNumber: '',
    lat: '',
    lng: '',
    terms: '',
    rates: '',
    ratesCount: '',
    apiToken: '',
    avatar: '',
    email: '',
    carCountryFactories: [],
    categories: [],
    city: CityModel(name: '', id: ''),
    howToKnowUs: HowToKnowUsModel(name: '', id: ''),
    region: RegionModel(name: '', id: ''),
    approved: '',
  );

  Future checkUser() async {
    await SharedPreferences.getInstance().then((value) {
      if (value.getString("type") != null) {
        if (value.getString("type") == "1") {
          _userModel = UserModel(
            firstName: value.getString("firstName") ?? "",
            lastName: value.getString("lastName") ?? "",
            phoneNumber: value.getString("phone") ?? "",
            apiToken: value.getString("api_token") ?? "",
            avatar: value.getString("avatar") ?? "",
            email: value.getString("email") ?? "",
          );
        }
        if (value.getString("type") == "2") {
          _provider = ProviderModel(
            id: value.getString("id") ?? "",
            providerName: value.getString("provider_name") ?? "",
            phone: value.getString("phone") ?? "",
            commercialRegistrationNumber:
                value.getString("commercial_registration_number") ?? "",
            taxNumber: value.getString("tax_number") ?? "",
            lat: value.getString("lat") ?? "",
            lng: value.getString("lng") ?? "",
            terms: value.getString("terms") ?? "",
            rates: value.getString("rates") ?? "",
            ratesCount: value.getString("rates_count") ?? "",
            apiToken: value.getString("api_token") ?? "",
            avatar: value.getString("avatar") ?? "",
            email: value.getString("email") ?? "",
            carCountryFactories: [],
            categories: [],
            city: CityModel(name: '', id: ''),
            howToKnowUs: HowToKnowUsModel(name: '', id: ''),
            region: RegionModel(name: '', id: ''),
            approved: '',
          );
        }
        log(_provider.apiToken);
        setState(() {});
      }
    });
  }

  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      isConnected = await InternetConnectionChecker().hasConnection;
      setState(() {});
    });
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (_, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ProviderProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CarProvider(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'صون',
          theme: ThemeData(
            splashColor: kBlueColor,
            hintColor: kGreyColor,
            backgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              accentColor: kBlueColor,
            ).copyWith(
              secondary: Colors.white,
              primary: kBlueColor,
            ),
          ),
          home: !isConnected
              ? const NoConnectionView()
              : _userModel.apiToken == '' && _provider.apiToken == ''
                  ? const IntroductionView()
                  : _userModel.apiToken != '' && _provider.apiToken == ''
                      ? LandingView(
                          user: _userModel,
                        )
                      : PlandingView(
                          provider: _provider,
                        ),
          routes: {
            SignInView.routeName: (context) => const SignInView(),
            SignUpTypeView.routeName: (context) => const SignUpTypeView(),
            UserFirstSignUpView.routeName: (context) =>
                const UserFirstSignUpView(),
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
