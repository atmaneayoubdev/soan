import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'text_widget.dart';
import '../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    Key? key,
    required this.isActive,
    required this.isred,
    required this.name,
    required this.image,
  }) : super(key: key);
  final bool isActive;
  final bool isred;
  final String name;
  final String image;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: widget.isActive ? kSkyBleuColor : kLightLightGreyColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: widget.isred ? Colors.red : Colors.transparent,
          )),
      height: 120.h,
      width: 105.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                color: widget.isActive ? Colors.white : Colors.black,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: kLightLightSkyBlueColor,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Center(
            child: TextWidget(
                text: widget.name,
                size: 14,
                color: widget.isActive ? Colors.white : kDarkBleuColor,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
