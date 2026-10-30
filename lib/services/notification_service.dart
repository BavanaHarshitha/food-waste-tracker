import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/food_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
    );

    final AndroidFlutterLocalNotificationsPlugin?
        androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'food_expiry_channel',
      'Food Expiry Notifications',
      channelDescription:
          'Notifications about food expiry dates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
  static Future<void> checkExpiryNotifications(
  List<FoodItem> foods,
) async {
  for (final food in foods) {
    final int daysRemaining = food.daysRemaining;

    if (daysRemaining >= 0 && daysRemaining <= 3) {
      String message;

      if (daysRemaining == 0) {
        message = '${food.name} expires today. Please use it soon.';
      } else if (daysRemaining == 1) {
        message = '${food.name} expires tomorrow. Please use it soon.';
      } else {
        message =
            '${food.name} expires in $daysRemaining days. Please use it soon.';
      }

      await showNotification(
        id: food.id.hashCode,
        title: 'Food Expiring Soon',
        body: message,
      );
    }
  }
}
}