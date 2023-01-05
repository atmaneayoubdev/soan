class NotificationModel {
  String id;
  String orderId;
  String notificationType;
  String message;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.orderId,
    required this.notificationType,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"].toString(),
        orderId: json["order_id"].toString(),
        notificationType: json["notification_type"].toString(),
        message: json["message"].toString(),
        createdAt: json['created_at'].toString(),
      );
}
