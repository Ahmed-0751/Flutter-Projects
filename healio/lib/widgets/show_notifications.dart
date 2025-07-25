// lib/widgets/blood_request_notification_sheet.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestNotificationSheet extends StatelessWidget {
  const BloodRequestNotificationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("🔔 Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bloodRequests')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("No notifications yet.");
                    }

                    final notifications = snapshot.data!.docs;

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final data =
                        notifications[index].data() as Map<String, dynamic>;

                        final name = data['name'] ?? 'Unknown';
                        final bloodType = data['bloodType'] ?? 'N/A';
                        final location = data['location'] ?? 'Unknown';
                        final timestamp =
                        (data['timestamp'] as Timestamp?)?.toDate();
                        final formattedTime = timestamp != null
                            ? '${timestamp.toLocal()}'.split('.')[0]
                            : 'Unknown time';

                        return ListTile(
                          leading: const Icon(Icons.bloodtype, color: Colors.red),
                          title: Text('$name needs $bloodType'),
                          subtitle: Text('Location: $location\nTime: $formattedTime'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
