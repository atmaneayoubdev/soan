import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soan/controllers/provider_controller.dart';
import 'package:soan/helpers/provider.provider.dart';
import 'package:soan/models/auth/provider_model.dart';
import 'package:soan/models/auth/user_model.dart';
import 'package:soan/models/global/city_model.dart';
import 'package:soan/models/global/how_to_know_us_model.dart';
import 'package:soan/models/global/location_model.dart';
import 'package:soan/models/global/price_model.dart';
import 'package:soan/models/global/region_model.dart';
import 'package:soan/models/provider/dues_order_model.dart';
import 'package:soan/translations/locale_keys.g.dart';
import '../../../../Common/text_widget.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../models/global/invoice_model.dart';

class BillWidget extends StatefulWidget {
  const BillWidget({
    Key? key,
    required this.order,
  }) : super(key: key);
  final DuesOrderModel order;

  @override
  State<BillWidget> createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
  InvoiceModel invoice = InvoiceModel(
      id: '',
      createdAt: '',
      locaiton: LocationModel(
          addressName: '',
          locationName: '',
          region: RegionModel(name: '', id: ''),
          lat: '',
          lng: '',
          city: CityModel(name: '', id: '')),
      prices: PriceModel(subTotal: '', vat: '', total: ''),
      invoiceItems: [],
      customer: UserModel(
          firstName: '',
          lastName: '',
          phoneNumber: '',
          apiToken: '',
          avatar: '',
          email: ''),
      provider: ProviderModel(
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
          howToKnowUs: HowToKnowUsModel(id: '', name: ''),
          region: RegionModel(name: '', id: ''),
          approved: ''));

  Future getInvoice() async {
    await ProviderController.getInvoice(
      language: context.locale.languageCode,
      token: Provider.of<ProviderProvider>(context, listen: false)
          .providerModel
          .apiToken,
      id: widget.order.id,
    ).then((value) {
      setState(() {});
      if (value.runtimeType == InvoiceModel) {
        invoice = value;
        DateTime date = DateTime.parse(invoice.createdAt);
        invoice.createdAt = DateFormat('MM/dd/yyyy').format(date);
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    getInvoice();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      //height: 79.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: kLightLightSkyBlueColor,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            height: 62.h,
            width: 62.w,
            decoration: BoxDecoration(
                color: kLightLightGreyColor,
                borderRadius: BorderRadius.circular(10.r)),
            child: Center(
                child: SvgPicture.asset(
              "assets/icons/bill.svg",
            )),
          ),
          SizedBox(
            width: 18.w,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                    text: "${LocaleKeys.titles_invoice.tr()} #${invoice.id}",
                    size: 14,
                    color: kDarkBleuColor,
                    fontWeight: FontWeight.normal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                        text: LocaleKeys.provider_settings_date.tr(),
                        size: 14,
                        color: kLightDarkBleuColor,
                        fontWeight: FontWeight.normal),
                    SizedBox(
                      width: 5.w,
                    ),
                    TextWidget(
                        text: invoice.createdAt,
                        size: 14,
                        color: kDarkBleuColor,
                        fontWeight: FontWeight.normal)
                  ],
                ),
              ],
            ),
          ),
          //const Spacer(),
          SizedBox(
            width: 10.w,
          ),
          TextWidget(
            text: "${widget.order.dues} - ${LocaleKeys.common_sar.tr()}",
            size: 14,
            color: kPinkColor,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
