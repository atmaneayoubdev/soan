import 'package:soan/models/global/info_model.dart';
import 'package:soan/models/global/social_model.dart';

class SettingsModel {
  SocialModel social;
  InfoModel info;

  SettingsModel({
    required this.social,
    required this.info,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        info: InfoModel.fromJson(json["info"]),
        social: SocialModel.fromJson(json["social"]),
      );
}
