import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final DatabaseMethods _db = DatabaseMethods();
  _NotifCategory _selectedFilter = _NotifCategory.all;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  List<_NotificationItem> _mapDocs(List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final category = _parseCategory(data['category']);
      return _NotificationItem(
        docId: doc.id,
        icon: IconData(
          _asInt(data['iconCodePoint']) ?? Icons.notifications.codePoint,
          fontFamily: 'MaterialIcons',
        ),
        color: Color(_asInt(data['colorValue']) ?? 0xFF7C4DFF),
        title: data['title'] as String? ?? '',
        message: data['message'] as String? ?? '',
        time: _formatTime(_toTimestamp(data['createdAt'])),
        isUnread: !(data['isRead'] as bool? ?? false),
        category: category,
      );
    }).toList();
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Timestamp? _toTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);
    if (value is int) {
      return Timestamp.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      final dt = DateTime.tryParse(value);
      if (dt != null) return Timestamp.fromDate(dt);
    }
    return null;
  }

  _NotifCategory _parseCategory(dynamic raw) {
    final value = (raw as String? ?? '').trim().toLowerCase();
    switch (value) {
      case 'workout':
      case 'workouts':
      case 'strength':
      case 'cardio':
        return _NotifCategory.workout;
      case 'achievement':
      case 'achievements':
        return _NotifCategory.achievement;
      case 'reminder':
      case 'reminders':
        return _NotifCategory.reminder;
      case 'progress':
        return _NotifCategory.progress;
      default:
        return _NotifCategory.all;
    }
  }

  String _formatTime(Timestamp? ts) {
    if (ts == null) return '';
    final diff = DateTime.now().difference(ts.toDate());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    final dt = ts.toDate();
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Future<void> _markAllRead() async {
    final uid = _uid;
    if (uid == null) return;
    await _db.markAllNotificationsRead(uid);
  }

  Future<void> _markNotificationRead(_NotificationItem item) async {
    if (!item.isUnread) return;
    final uid = _uid;
    if (uid == null) return;
    await _db.markNotificationRead(uid, item.docId);
  }

  Future<void> _dismissNotification(_NotificationItem item) async {
    final uid = _uid;
    if (uid == null) return;
    await _db.deleteNotification(uid, item.docId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.title}" dismissed'),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uid = _uid;

    return StreamBuilder<QuerySnapshot>(
      stream: uid != null
          ? _db.getNotificationsStream(uid)
          : const Stream.empty(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Could not load notifications. Please try again.'),
            ),
          );
        }

        final allItems = snapshot.hasData
            ? _mapDocs(snapshot.data!.docs)
            : <_NotificationItem>[];
        final filtered = _selectedFilter == _NotifCategory.all
            ? allItems
            : allItems.where((n) => n.category == _selectedFilter).toList();
        final unreadCount = allItems.where((n) => n.isUnread).length;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            actions: [
              if (unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text(
                    'Read all',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          body: uid == null
              ? const Center(
                  child: Text('Please sign in to view notifications.'),
                )
              : snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _NotifCategory.values.map((cat) {
                          final isSelected = _selectedFilter == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat.label),
                              selected: isSelected,
                              onSelected: (_) =>
                                  setState(() => _selectedFilter = cat),
                              selectedColor: Colors.deepPurple.withValues(
                                alpha: 0.15,
                              ),
                              checkmarkColor: Colors.deepPurple,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.deepPurple
                                    : (isDark
                                          ? Colors.white70
                                          : Colors.black54),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.deepPurple
                                      : Colors.grey.shade300,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: filtered.isEmpty
                          ? _buildEmptyState(isDark)
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final notif = filtered[index];
                                return Dismissible(
                                  key: ValueKey(notif.docId),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (_) =>
                                      _dismissNotification(notif),
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 24),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  child: _buildNotificationTile(notif, isDark),
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

  Widget _buildNotificationTile(_NotificationItem notif, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _markNotificationRead(notif),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.isUnread
                ? Colors.deepPurple.withValues(alpha: isDark ? 0.12 : 0.05)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: notif.isUnread
                ? Border.all(
                    color: Colors.deepPurple.withValues(alpha: 0.25),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notif.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(notif.icon, color: notif.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notif.isUnread
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (notif.isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif.time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

enum _NotifCategory {
  all('All'),
  workout('Workouts'),
  achievement('Achievements'),
  reminder('Reminders'),
  progress('Progress');

  final String label;
  const _NotifCategory(this.label);
}

class _NotificationItem {
  final String docId;
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  final bool isUnread;
  final _NotifCategory category;

  const _NotificationItem({
    required this.docId,
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.category,
  });
}
