import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_local_notification/services/utils.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationServices {
  LocalNotificationServices();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceivedLocalNotification);

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _localNotificationService.initialize(settings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showNotificaiton(
      {required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showSchNotificaiton(
      {required int id,
      required String title,
      required String body,
      required int sec}) async {
    final details = await _notificationDetails();

    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
            DateTime.now().add(Duration(seconds: sec)), tz.local),
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<NotificationDetails> _notificationDetails() async {
    final largeIconImg = await Utils.downloadFile(
        "https://www.tailorbrands.com/wp-content/uploads/2020/07/mcdonalds-logo.jpg",
        "fileName");
    final styleNotificationInfo = BigPictureStyleInformation(
        FilePathAndroidBitmap(largeIconImg),
        largeIcon: FilePathAndroidBitmap(largeIconImg));

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            channelDescription: 'decs',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            styleInformation: styleNotificationInfo);

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  void onSelectNotification(String? payload) {
    print(payload);
  }

  onDidReceivedLocalNotification(
      int? id, String? title, String? body, String? payload) {
    print(id);
  }
}
