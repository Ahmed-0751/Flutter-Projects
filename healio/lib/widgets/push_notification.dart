import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendPushNotification(String token, {required String title, required String body}) async {
  const serverKey = 'YOUR_SERVER_KEY_HERE'; // from Firebase Cloud Messaging settings

  final data = {
    "to": token,
    "notification": {
      "title": title,
      "body": body,
    },
    "priority": "high",
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: headers,
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print("✅ Notification sent");
  } else {
    print("❌ Failed to send notification: ${response.body}");
  }
}
