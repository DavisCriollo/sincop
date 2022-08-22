import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();





  
  // String sound = 'notification.mp3';
  static Future _notificationDetails() async {
    return  const NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel id',
        'Channel Name',
        channelDescription: 'Channel description',
        importance: Importance.max,
       sound: RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: IOSNotificationDetails(
        sound: 'notification.mp3',
      ),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final androide = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final setting = InitializationSettings(android: androide, iOS: iOS);

// WHEN APP IS CLOSED

    final details = await _notifications.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.payload);
    }

    await _notifications.initialize(
      setting,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

static void cancel(int id)=>_notifications.cancel(id);
static void cancelAll()=>_notifications.cancelAll();




}
