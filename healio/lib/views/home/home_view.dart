import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healio/controllers/auth_controller.dart';
import 'package:healio/models/blood_request_model.dart';
import 'package:healio/views/home/firstAid_view.dart';
import '../../../widgets/blood_request_dialog.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/blood_request_card.dart';
import '../../widgets/google_maps.dart';
import '../../widgets/show_notifications.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    final authController = AuthController();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text("Home"),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const BloodRequestNotificationSheet(),
                  );
                },
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("Logout"),
                            onPressed: () {
                              Navigator.pop(context);
                              authController.logoutUser();
                            },
                          ),
                        ],
                      ),
                    );
                  },

                  icon: Icon(Icons.logout))
            ],
          )
        ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBloodRequestDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Emergency Access", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.local_hospital),
                    label: const Text("Call Ambulance"),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Call'),
                          content: const Text('Are you sure you want to call the ambulance (1020)?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Call')),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        var status = await Permission.phone.status;
                        if (!status.isGranted) {
                          status = await Permission.phone.request();
                        }
                        if (status.isGranted) {
                          await FlutterPhoneDirectCaller.callNumber('1020');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Phone call permission not granted")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.healing),
                    label: const Text("First Aid"),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const FirstAidView()));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text("Recent Blood Requests", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            // 🔴 Firestore Stream: Live blood requests
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bloodRequests')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("There are no blood requests yet.");
                }

                // ⏰ Filter out old entries (older than 36 hours)
                final validRequests = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
                  if (timestamp == null) return false;
                  return DateTime.now().difference(timestamp).inHours <= 36;
                }).toList();

                if (validRequests.isEmpty) {
                  return const Text("No active blood requests (older than 36 hours removed).");
                }

                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: validRequests.length,
                    itemBuilder: (context, index) {
                      final doc = validRequests[index];
                      final request = BloodRequest.fromMap(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SizedBox(
                          width: 300,
                          child: BloodRequestCard(request: request),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10,),
            Text('Nearest Hospitals', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10,),
            Expanded(
                child: GestureDetector(
                  onTap: openGoogleMaps,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/gm1.jpg'),
                      fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.red,
                    ),

                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
}
