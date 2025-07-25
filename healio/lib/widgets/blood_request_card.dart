import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this in pubspec.yaml
import '../models/blood_request_model.dart';

class BloodRequestCard extends StatelessWidget {
  final BloodRequest request;

  const BloodRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('yyyy-MM-dd – hh:mm a').format(request.timestamp.toDate());
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(

      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Delete Icon (if author)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Name: ${request.name}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (currentUser != null && currentUser.uid == request.userId)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('bloodRequests')
                              .doc(request.id)
                              .delete();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(
                                'Request deleted successfully')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Delete failed: $e')),
                          );
                        }
                      },

                    ),

                ],
              ),
            ),
            Text("Blood Type: ${request.bloodType}", style: const TextStyle(fontSize: 14)),
            Text("Location: ${request.location}", style: const TextStyle(fontSize: 14)),
            Text("Contact: ${request.contact}", style: const TextStyle(fontSize: 14)),
            Text("Requested on: $formattedTime", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),

          ],
        ),
      ),
    );
  }
}