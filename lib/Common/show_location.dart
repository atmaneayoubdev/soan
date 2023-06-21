import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class ShowLocationView extends StatefulWidget {
  const ShowLocationView({Key? key, required this.currentLocation})
      : super(key: key);
  final LatLng currentLocation;

  @override
  State<ShowLocationView> createState() => _ShowLocationViewState();
}

class _ShowLocationViewState extends State<ShowLocationView> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CameraPosition? _initialPosition;
  Marker? marker;
  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target: widget.currentLocation,
      zoom: 18,
    );

    Marker marker = Marker(
      markerId: const MarkerId("0"),
      position: widget.currentLocation,
    );
    markers[const MarkerId("0")] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        //height: 800.h,
        width: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              markers: Set<Marker>.of(markers.values),
              padding: const EdgeInsets.all(10),
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            // Center(
            //     child: SvgPicture.asset(
            //   "assets/icons/map_marker_icon.svg",
            //   height: 40.h,
            // ))
            const SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: kBlueColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
