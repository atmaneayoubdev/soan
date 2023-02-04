import 'package:easy_localization/easy_localization.dart';
import 'package:soan/translations/locale_keys.g.dart';

class SliderModel {
  String? imageAssetPath;
  String? title;
  String? desc;

  SliderModel({this.imageAssetPath, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath!;
  }

  String getDesc() {
    return desc!;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

  //1
  sliderModel.setDesc(LocaleKeys.intoduction_page3.tr());
  sliderModel.setImageAssetPath("assets/images/Intro1.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //2
  sliderModel.setDesc(
    LocaleKeys.intoduction_page2.tr(),
  );
  sliderModel.setImageAssetPath("assets/images/Intro2.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  //3
  sliderModel.setDesc(LocaleKeys.intoduction_page1.tr());
  sliderModel.setImageAssetPath("assets/images/Intro3.png");
  slides.add(sliderModel);

  sliderModel = SliderModel();

  return slides;
}
