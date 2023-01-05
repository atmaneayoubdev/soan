// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/costumer_controller.dart';
import 'package:soan/helpers/user_provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import '../../../../Common/category_widget.dart';
import '../../../../controllers/global_controller.dart';
import '../../../../models/global/categories_model.dart';
import '../../../../Common/title_widget.dart';
import '../components/soan_providers_widger.dart';
import 'package:geolocator/geolocator.dart';

class SoanProvidersView extends StatefulWidget {
  const SoanProvidersView({Key? key}) : super(key: key);

  @override
  State<SoanProvidersView> createState() => _SoanProvidersViewState();
}

class _SoanProvidersViewState extends State<SoanProvidersView> {
  bool isNear = true;
  List<CategoryModel> _categories = [];
  List<ProviderModel> _providers = [];
  CategoryModel? _selectedCategory;
  bool isLoading = true;
  LatLng? latLng;

  Future getCategories() async {
    if (mounted) {
      await GlobalController.getCategories().then((value) {
        if (mounted) {
          setState(() {
            _categories = value;
            _selectedCategory = _categories.first;
          });
        }
      }).then((value) {
        if (mounted) {
          getProviders(
            Provider.of<UserProvider>(context, listen: false).user.apiToken,
            _selectedCategory!.id,
            isNear ? false : true,
          );
        }
      });
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys
              .costumer_providers_permission_denied_activate_location
              .tr()),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.costumer_providers_permission_denied.tr()),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              LocaleKeys.costumer_providers_we_can_not_request_permission.tr()),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      log(position.latitude.toString());
      setState(() => latLng = LatLng(position.latitude, position.longitude));
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future getProviders(
      String token, String categoryId, bool searchTopRate) async {
    isLoading = true;
    setState(() {});
    if (isNear) {
      _getCurrentPosition().then((value) async {
        log(latLng.toString());
        if (latLng != null) {
          await CostumerController.getProvidersList(
            token: token,
            isNear: true,
            categoryId: categoryId,
            latLng: latLng != null
                ? LatLng(latLng!.latitude, latLng!.longitude)
                : null,
          ).then((value) {
            _providers = value;
            isLoading = false;
            if (mounted) {
              setState(() {});
            }
          });
        } else {
          isLoading = false;
          setState(() {});
        }
      });
    } else {
      await CostumerController.getProvidersList(
        token: token,
        isNear: false,
        categoryId: categoryId,
      ).then((value) {
        _providers = value;
        isLoading = false;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getCategories();
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
              title: LocaleKeys.titles_providers.tr(),
              isProvider: false,
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                height: 200.h,
                width: 385.w,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3),
                        spreadRadius: 7,
                        blurRadius: 10,
                        color: Colors.black12),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SizedBox(
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
                          if (_selectedCategory != cat) {
                            _selectedCategory = cat;
                            setState(() {});
                            getProviders(
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .apiToken,
                                _selectedCategory!.id,
                                isNear ? false : true);
                          }
                        },
                        child: CategoryWidget(
                          isActive: _selectedCategory == cat,
                          image: cat.image,
                          isred: false,
                          name: cat.name,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!isNear) {
                      setState(() {
                        isNear = true;
                      });
                      _providers.clear();

                      getProviders(
                        Provider.of<UserProvider>(context, listen: false)
                            .user
                            .apiToken,
                        _selectedCategory!.id,
                        isNear ? false : true,
                      );
                    }
                  },
                  child: SizedBox(
                    width: 156.w,
                    child: TextWidget(
                      text: LocaleKeys.costumer_providers_nearby_worshops.tr(),
                      size: 14,
                      color: isNear ? kDarkBleuColor : kLightDarkBleuColor,
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
                    if (isNear) {
                      setState(() {
                        isNear = false;
                      });
                      _providers.clear();
                      getProviders(
                          Provider.of<UserProvider>(context, listen: false)
                              .user
                              .apiToken,
                          _selectedCategory!.id,
                          isNear ? false : true);
                    }
                  },
                  child: SizedBox(
                    width: 156.w,
                    child: TextWidget(
                      text: LocaleKeys.costumer_providers_top_rated_workshops
                          .tr(),
                      size: 14,
                      color: isNear ? kLightDarkBleuColor : kDarkBleuColor,
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
                      height: 2.h,
                      width: 384.w,
                      color: kLightLightGreyColor,
                    ),
                    context.locale.languageCode == 'en'
                        ? Align(
                            alignment: isNear
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              height: 2.h,
                              width: 384.w / 2,
                              color: kDarkBleuColor,
                            ),
                          )
                        : Align(
                            alignment: isNear
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              height: 2.h,
                              width: 384.w / 2,
                              color: kDarkBleuColor,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              //height: 490.h,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: kBlueColor,
                      ),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _providers.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 12.h,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        ProviderModel provider = _providers[index];
                        return SoanProviderWidget(
                          provider: provider,
                        );
                      },
                    ),
            ),
          ],
        )
      ]),
    );
  }
}
