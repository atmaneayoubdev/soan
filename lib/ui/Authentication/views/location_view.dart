import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:soan/translations/locale_keys.g.dart';
import 'package:soan/ui/Authentication/views/provider_first_register_view.dart';
import '../../../Common/large_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key, this.selectedCity}) : super(key: key);
  final String? selectedCity;

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController title = TextEditingController();
  TextEditingController address = TextEditingController();
  LatLng _lastMapPosition = const LatLng(21.459858, 39.245219);
  Placemark place = Placemark(country: 'SA');
  LocModel? loc;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.8859, 45.0792),
    zoom: 6,
  );

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    log(position.target.toString());
  }

  Future onCameraStoped() async {
    List<Placemark> newPlace = await placemarkFromCoordinates(
      _lastMapPosition.latitude,
      _lastMapPosition.longitude,
      localeIdentifier: context.locale.languageCode,
    );
    setState(() {
      place = newPlace.first;
      title.text = place.locality!;
      address.text = place.street!;
    });
  }

  @override
  void didChangeDependencies() {
    onCameraStoped();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              color: kGreyColor,
              boxShadow: [
                BoxShadow(
                  color: kLightGreyColor,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 800.h,
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  padding: EdgeInsets.symmetric(vertical: 50.h),

                  //markers: _markers,

                  onCameraIdle: onCameraStoped,
                  onCameraMove: _onCameraMove,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                  },
                ),
                Center(
                    child: SvgPicture.asset(
                  "assets/icons/map_marker_icon.svg",
                  height: 40.h,
                ))
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70.h,
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (place.street != "")
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        width: 347.w,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: kLightGreyColor,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(14.r),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Text(
                              title.text,
                              style: GoogleFonts.tajawal(
                                fontSize: 16.sp,
                                color: kDarkBleuColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/location_icon.svg",
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Flexible(
                                  child: Text(
                                    address.text,
                                    overflow: TextOverflow.clip,
                                    maxLines: 10,
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14.sp,
                                      color: kGreyColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.selectedCity == place.locality!) {
                            Navigator.pop(
                              context,
                              LocModel(
                                  address: address.text,
                                  latLng: _lastMapPosition),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "${LocaleKeys.provider_home_locatoin_should_be_in.tr()} ${widget.selectedCity}",
                              ),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        child: LargeButton(
                          text: LocaleKeys.auth_confirm.tr(),
                          isButton: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
