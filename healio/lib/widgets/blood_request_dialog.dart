import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healio/widgets/push_notification.dart';

Future<void> showBloodRequestDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final bloodTypeController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Blood Request'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 5,),
              TextField(
                controller: bloodTypeController,
                decoration: const InputDecoration(labelText: 'Blood Type (e.g. A+, O-)'),
              ),
              SizedBox(height: 5,),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 5,),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact No'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final bloodType = bloodTypeController.text.trim();
              final location = locationController.text.trim();
              final contact = contactController.text.trim();

              if (name.isEmpty || bloodType.isEmpty || location.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All fields are required")),
                );
                return;
              }

              try {
                final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
                await FirebaseFirestore.instance.collection('bloodRequests').add({
                  'userId': userId,
                  'name': name,
                  'bloodType': bloodType,
                  'location': location,
                  'contact': contact,
                  'timestamp': FieldValue.serverTimestamp(), // ⏰ Important
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Blood request submitted")),
                );
                // After blood request is added
                final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

                for (var userDoc in usersSnapshot.docs) {
                  final token = userDoc['fcmToken'];
                  if (token != null && token != '') {
                    await sendPushNotification(
                      token,
                      title: 'New Blood Request',
                      body: '$name needs $bloodType blood at $location',
                    );
                  }
                }

              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to submit: $e")),
                );
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
