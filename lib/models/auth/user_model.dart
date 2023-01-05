class UserModel {
  String firstName;
  String lastName;
  String phoneNumber;
  String apiToken;
  String avatar;
  String email;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.apiToken,
    required this.avatar,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["first_name"].toString(),
        lastName: json["last_name"].toString(),
        phoneNumber: json["phone"].toString(),
        apiToken: json["api_token"].toString(),
        avatar: json["avatar"].toString(),
        email: json["email"].toString(),
      );
  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phoneNumber,
      "api_token": apiToken,
      "email": email,
      'avatar': avatar,
    };
  }
}
