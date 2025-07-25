import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest {
  final String id;
  final String userId;
  final String name;
  final String bloodType;
  final String location;
  final String contact; // ✅ NEW
  final Timestamp timestamp;

  BloodRequest({
    required this.id,
    required this.userId,
    required this.name,
    required this.bloodType,
    required this.location,
    required this.contact, // ✅ NEW
    required this.timestamp,
  });

  /// Factory constructor to create a BloodRequest from Firestore data
  factory BloodRequest.fromMap(String id, Map<String, dynamic> data) {
    return BloodRequest(
      id: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      bloodType: data['bloodType'] ?? '',
      location: data['location'] ?? '',
      contact: data['contact'] ?? '', // ✅ NEW
      timestamp: data['timestamp'] is Timestamp
          ? data['timestamp']
          : Timestamp.now(),
    );
  }

  /// Converts BloodRequest object to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'bloodType': bloodType,
      'location': location,
      'contact': contact, // ✅ NEW
      'timestamp': timestamp,
    };
  }
}
