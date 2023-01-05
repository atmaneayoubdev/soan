import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soan/Common/loading_widget.dart';
import 'package:soan/controllers/auth_controller.dart';
import 'package:soan/controllers/global_controller.dart';
import 'package:soan/models/global/car_country_factory_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/phone_verification.dart';
import '../../../Common/category_widget.dart';
import '../../../Common/large_button.dart';
import '../../../Common/text_widget.dart';
import '../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'signin_view.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderSecondRegisterView extends StatefulWidget {
  const ProviderSecondRegisterView(
      {Key? key,
      required this.companyName,
      required this.registrationNbr,
      required this.taxNbr,
      required this.areaId,
      required this.cityId,
      required this.lat,
      required this.lng,
      required this.phone,
      required this.howToKnowUs})
      : super(key: key);
  final String companyName;
  final String registrationNbr;
  final String taxNbr;
  final int areaId;
  final int cityId;
  final double lat;
  final double lng;
  final String phone;
  final int howToKnowUs;

  @override
  State<ProviderSecondRegisterView> createState() =>
      _ProviderSecondRegisterViewState();
}

class _ProviderSecondRegisterViewState
    extends State<ProviderSecondRegisterView> {
  TextEditingController emailControlelr = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isPassVisible = false;
  bool isPassConfVisible = false;
  final List<int> _selectedFactories = [];
  List<CarCountryFactoryModel> _factories = [];
  List<CategoryModel> _categories = [];
  final List<int> _selectedCategories = [];
  bool isListCollaps = false;
  bool isCatRed = false;
  bool isTypeRed = false;

  Future getFactories() async {
    await GlobalController.getCarCountryFactories().then((value) {
      setState(() {
        _factories = value;
      });
    });
  }

  Future getCategories() async {
    await GlobalController.getCategories().then((value) {
      setState(() {
        _categories = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    getFactories().then((value) {
      setState(() {
        isLoading = false;
      });
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
              SizedBox(
                height: 160.h,
                child: Center(
                  child: TextWidget(
                    text: LocaleKeys.titles_finish_data.tr(),
                    size: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 23.h,
                            ),
                            FittedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: TextWidget(
                                      text: LocaleKeys
                                          .auth_choose_workshop_category
                                          .tr(),
                                      size: 15,
                                      color: kDarkBleuColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  TextWidget(
                                    text: LocaleKeys
                                        .auth_you_can_choose_more_than_one
                                        .tr(),
                                    size: 12,
                                    color: kLightDarkBleuColor,
                                    fontWeight: FontWeight.normal,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                            SizedBox(
                              height: 120.h,
                              width: double.infinity,
                              child: ListView.separated(
                                padding: EdgeInsets.only(right: 10.w),
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 10.w,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  CategoryModel cat = _categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isCatRed = false;
                                        _selectedCategories
                                                .contains(int.parse(cat.id))
                                            ? _selectedCategories
                                                .remove(int.parse(cat.id))
                                            : _selectedCategories
                                                .add(int.parse(cat.id));
                                      });
                                    },
                                    child: CategoryWidget(
                                      isActive: _selectedCategories
                                          .contains(int.parse(cat.id)),
                                      image: cat.image,
                                      isred: isCatRed,
                                      name: cat.name,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isTypeRed
                                            ? Colors.red
                                            : kLightBlueColor),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: ExpansionTile(
                                    iconColor: kBlueColor,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        isListCollaps = !isListCollaps;
                                      });
                                    },
                                    title: Align(
                                      alignment:
                                          context.locale.languageCode == "en"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                      child: TextWidget(
                                        text:
                                            LocaleKeys.auth_car_factories.tr(),
                                        size: 18,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      !isListCollaps ? 0 : _factories.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CarCountryFactoryModel fact =
                                        _factories[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            isTypeRed = false;
                                            if (!_selectedFactories
                                                .contains(int.parse(fact.id))) {
                                              _selectedFactories
                                                  .add(int.parse(fact.id));
                                            } else {
                                              _selectedFactories
                                                  .remove(int.parse(fact.id));
                                            }
                                            setState(() {});
                                          },
                                          child: CarTypewidget(
                                            fact: fact,
                                            isSelected: _selectedFactories
                                                .contains(int.parse(fact.id)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(height: 10.h);
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 23.h,
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/icons/email.svg"),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      TextWidget(
                                        text: LocaleKeys.auth_email.tr(),
                                        size: 16,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    controller: emailControlelr,
                                    maxLines: 1,
                                    validator: (value) {
                                      String pattern =
                                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                          r"{0,253}[a-zA-Z0-9])?)*$";
                                      RegExp regex = RegExp(pattern);
                                      if (value == null ||
                                          value.isEmpty ||
                                          !regex.hasMatch(value)) {
                                        return LocaleKeys.auth_enter_valid_email
                                            .tr();
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: formFieldDecoration,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 35.h,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/lock.svg"),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      TextWidget(
                                        text: LocaleKeys.auth_password.tr(),
                                        size: 16,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: !isPassVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LocaleKeys
                                            .auth_enter_valid_password
                                            .tr();
                                      }

                                      if (value != confirmPassController.text) {
                                        return LocaleKeys
                                            .auth_password_not_matching
                                            .tr();
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration!.copyWith(
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPassVisible = !isPassVisible;
                                          });
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: !isPassVisible
                                              ? kOrangeColor
                                              : kGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 35.h,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/icons/lock.svg"),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      TextWidget(
                                        text: LocaleKeys.auth_confirm_password
                                            .tr(),
                                        size: 16,
                                        color: kDarkBleuColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  TextFormField(
                                    controller: confirmPassController,
                                    obscureText: !isPassConfVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LocaleKeys
                                            .auth_enter_valid_password
                                            .tr();
                                      }

                                      if (value != confirmPassController.text) {
                                        return LocaleKeys
                                            .auth_password_not_matching
                                            .tr();
                                      }
                                      return null;
                                    },
                                    decoration: formFieldDecoration!.copyWith(
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isPassConfVisible =
                                                !isPassConfVisible;
                                          });
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: !isPassConfVisible
                                              ? kOrangeColor
                                              : kGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 120.h,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_selectedCategories.isEmpty) {
                              setState(() {
                                isCatRed = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    LocaleKeys.auth_choose_workshop_category
                                        .tr(),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (_selectedFactories.isEmpty) {
                              setState(() {
                                isTypeRed = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    LocaleKeys.auth_choose_factories.tr(),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthController.providerRigester(
                                      companyName: widget.companyName,
                                      phone: widget.phone,
                                      email: emailControlelr.text,
                                      password: passwordController.text,
                                      comercialRegistrationNbr:
                                          widget.registrationNbr,
                                      taxNbr: widget.taxNbr,
                                      lat: widget.lat,
                                      lng: widget.lng,
                                      regionId: widget.areaId,
                                      cityId: widget.cityId,
                                      howToKnowUs: widget.howToKnowUs,
                                      categories: _selectedCategories,
                                      factories: _selectedFactories,
                                      deviceToken: "2345234524")
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });

                                if (value != "error") {
                                  if (value.toString().length == 4 &&
                                      value.toString() != 'null') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhoneVerification(
                                          from: 'provider',
                                          number: widget.phone,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          value.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              });
                            }
                          },
                          child: LargeButton(
                              text: LocaleKeys.auth_create.tr(),
                              isButton: false),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  SignInView.routeName,
                                  (Route<dynamic> route) => false);
                            },
                            child: Container(
                              height: 51.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: kBlueColor),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ' ${LocaleKeys.auth_have_an_account.tr()} ',
                                    style: GoogleFonts.tajawal(
                                      color: kDarkBleuColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Text(
                                    LocaleKeys.titles_singin.tr(),
                                    style: GoogleFonts.tajawal(
                                        color: kGreenColor, fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
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

class CarTypewidget extends StatelessWidget {
  const CarTypewidget({
    Key? key,
    required this.fact,
    required this.isSelected,
  }) : super(key: key);

  final CarCountryFactoryModel fact;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: fact.name,
              size: 16,
              color: kBlueColor,
              fontWeight: FontWeight.normal,
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.add,
              color: kBlueColor,
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(),
      ],
    );
  }
}
