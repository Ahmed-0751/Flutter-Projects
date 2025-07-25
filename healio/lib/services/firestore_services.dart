import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a document to blood_requests collection
  Future<void> addBloodRequest(Map<String, dynamic> data) async {
    await _db.collection('blood_requests').add(data);
  }

  // Get all blood requests as stream
  Stream<QuerySnapshot> getBloodRequests() {
    return _db.collection('blood_requests').orderBy('timestamp', descending: true).snapshots();
  }

  // Delete a request by ID
  Future<void> deleteRequest(String docId) async {
    await _db.collection('blood_requests').doc(docId).delete();
  }
}
