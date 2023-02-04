import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/controllers/global_controller.dart';
import 'package:soan/helpers/car_provider.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/constumer/car_model.dart';
import 'package:soan/models/global/categories_model.dart';
import 'package:soan/models/global/slider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/customer/home/views/create_order_view.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../components/home_add_widget.dart';
import '../../../../Common/category_widget.dart';
import '../../../../Common/title_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<HomesliderModel> _sliders = [];
  List<CategoryModel> _categories = [];

  Future getSliders() async {
    if (mounted) {
      await GlobalController.getSlidersList(context.locale.languageCode)
          .then((value) {
        _sliders = value;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future getCategories() async {
    if (mounted) {
      await GlobalController.getCategories(context.locale.languageCode)
          .then((value) {
        if (mounted) {
          setState(() {
            _categories = value;
          });
        }
      });
    }
  }

  Future getCurrentCar() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getString('currentCarId') != null) {
        if (prefs.getString('currentCarId')!.isNotEmpty) {
          await CostumerController.getCarInfo(
            language: context.locale.languageCode,
            token:
                Provider.of<UserProvider>(context, listen: false).user.apiToken,
            id: prefs.getString('currentCarId')!,
          ).then((car) {
            if (car.runtimeType == CarModel) {
              Provider.of<CarProvider>(context, listen: false).setCar(car);
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCurrentCar();
      getCategories();
      getSliders();
      log(Provider.of<UserProvider>(context, listen: false).user.apiToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/home_back.png",
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 63.h,
              ),
              TitleWidget(
                title: LocaleKeys.titles_home.tr(),
                isProvider: false,
              ),
              const HomeAddWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: TextWidget(
                  text: LocaleKeys.costumer_home_select_problem_type.tr(),
                  size: 18,
                  color: kLightDarkBleuColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 120.h,
                width: double.infinity,
                child: ListView.separated(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 10.w,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    CategoryModel cat = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => CreateOrderView(
                                  categoryModel: cat,
                                )),
                          ),
                        );
                      },
                      child: CategoryWidget(
                        isActive: false,
                        image: cat.image,
                        isred: false,
                        name: cat.name,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: SizedBox(
                  height: 150.h,
                  width: 390.w,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 150.h,
                      autoPlay: true,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      disableCenter: true,
                    ),
                    items: _sliders.map((slide) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CachedNetworkImage(
                              imageUrl: slide.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: kLightLightSkyBlueColor,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
