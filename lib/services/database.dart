import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _users => _db.collection('users');
  CollectionReference get _workouts => _db.collection('workouts');

  Future<void> addUser(String uid, Map<String, dynamic> userInfo) async {
    await _users.doc(uid).set(userInfo);
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return _users.doc(uid).get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    await _users.doc(uid).update(updates);
  }

  Future<void> deleteUser(String uid) async {
    await _users.doc(uid).delete();
  }

  Stream<DocumentSnapshot> userStream(String uid) {
    return _users.doc(uid).snapshots();
  }

  Future<DocumentReference> addWorkout(
    String uid,
    Map<String, dynamic> workoutData,
  ) async {
    workoutData['completedAt'] ??= FieldValue.serverTimestamp();
    return _users.doc(uid).collection('workoutLogs').add(workoutData);
  }

  Stream<QuerySnapshot> getWorkoutLogsStream(String uid) {
    return _users
        .doc(uid)
        .collection('workoutLogs')
        .orderBy('completedAt', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getWorkoutLogs(String uid) async {
    return _users
        .doc(uid)
        .collection('workoutLogs')
        .orderBy('completedAt', descending: true)
        .get();
  }

  Future<void> updateWorkout(
    String uid,
    String logId,
    Map<String, dynamic> updates,
  ) async {
    await _users.doc(uid).collection('workoutLogs').doc(logId).update(updates);
  }

  Future<void> deleteWorkout(String uid, String logId) async {
    await _users.doc(uid).collection('workoutLogs').doc(logId).delete();
  }

  Stream<QuerySnapshot> getWorkoutCatalogStream() {
    return _workouts.orderBy('title').snapshots();
  }

  Future<DocumentReference> addWorkoutToCatalog(
    Map<String, dynamic> workoutData,
  ) async {
    return _workouts.add(workoutData);
  }

  Future<void> incrementStats({
    required String uid,
    required int calories,
    required int minutes,
  }) async {
    await _users.doc(uid).update({
      'totalWorkouts': FieldValue.increment(1),
      'totalCalories': FieldValue.increment(calories),
      'totalMinutes': FieldValue.increment(minutes),
    });
  }

  Future<Map<String, dynamic>> getUserStats(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return {};
    final data = doc.data() as Map<String, dynamic>;
    return {
      'totalWorkouts': data['totalWorkouts'] ?? 0,
      'totalCalories': data['totalCalories'] ?? 0,
      'totalMinutes': data['totalMinutes'] ?? 0,
    };
  }

  Future<void> addNotification(
    String uid,
    Map<String, dynamic> notificationData,
  ) async {
    notificationData['createdAt'] ??= FieldValue.serverTimestamp();
    notificationData['isRead'] ??= false;
    await _users.doc(uid).collection('notifications').add(notificationData);
  }

  Stream<QuerySnapshot> getNotificationsStream(String uid) {
    return _users
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markNotificationRead(String uid, String notifId) async {
    await _users.doc(uid).collection('notifications').doc(notifId).update({
      'isRead': true,
    });
  }

  Future<void> deleteNotification(String uid, String notifId) async {
    await _users.doc(uid).collection('notifications').doc(notifId).delete();
  }

  Future<void> markAllNotificationsRead(String uid) async {
    final batch = _db.batch();
    final snapshot = await _users
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Saves a support request (email contact or bug report) to Firestore.
  /// [uid] may be null for unauthenticated users.
  Future<void> addSupportRequest(Map<String, dynamic> data) async {
    data['createdAt'] ??= FieldValue.serverTimestamp();
    data['status'] ??= 'open';
    await _db.collection('supportRequests').add(data);
  }
}
