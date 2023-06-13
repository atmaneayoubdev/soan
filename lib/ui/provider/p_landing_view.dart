import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/views/p_home_view.dart';
import 'notifications/views/p_notification_view.dart';
import 'orders/views/p_orders_view.dart';
import 'settings/views/p_settigns_view.dart';

class PlandingView extends StatefulWidget {
  const PlandingView({Key? key, this.selectedIndex, this.provider})
      : super(key: key);
  static const String routeName = '/tab';
  static GlobalKey<ScaffoldState> akey = GlobalKey();
  final int? selectedIndex;
  final ProviderModel? provider;

  @override
  State<PlandingView> createState() => _PlandingViewState();
}

class _PlandingViewState extends State<PlandingView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    if (widget.provider != null) {
      Provider.of<ProviderProvider>(context, listen: false).providerModel =
          widget.provider!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem("assets/icons/nav_home_icon.svg", 0),
          buildNavBarItem("assets/icons/nav_orders_icon.svg", 1),
          buildNavBarItem("assets/icons/home_notification.svg", 2),
          buildNavBarItem("assets/icons/nav_settings_icon.svg", 3),
        ],
      ),
      body: _selectedIndex == 0
          ? const PhomeView()
          : _selectedIndex == 1
              ? const PordersView()
              : _selectedIndex == 2
                  ? const PnotificationView(
                      isBack: false,
                    )
                  : const PsettingsView(),
    );
  }

  buildNavBarItem(String icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 92.h,
        width: MediaQuery.of(context).size.width / 4,
        decoration: const BoxDecoration(color: Colors.white, boxShadow: []),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                // ignore: deprecated_member_use
                color: _selectedIndex == index ? kDarkBleuColor : kGreyColor,
                height: _selectedIndex != index ? 20.h : 25.h,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                index == 0
                    ? LocaleKeys.titles_home.tr()
                    : index == 1
                        ? LocaleKeys.titles_orders.tr()
                        : index == 2
                            ? LocaleKeys.titles_notifications.tr()
                            : LocaleKeys.titles_settings.tr(),
                style: GoogleFonts.tajawal(
                  fontSize: 13.sp,
                  fontWeight: _selectedIndex == index
                      ? FontWeight.w700
                      : FontWeight.w600,
                  color: _selectedIndex == index ? kDarkBleuColor : kGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
