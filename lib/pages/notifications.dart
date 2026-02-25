import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_NotificationItem> _notifications = [
    _NotificationItem(
      icon: Icons.fitness_center,
      color: const Color(0xFF7C4DFF),
      title: 'Workout Complete!',
      message: 'Great job finishing your upper body session. Keep it up!',
      time: '2 min ago',
      isUnread: true,
      category: _NotifCategory.workout,
    ),
    _NotificationItem(
      icon: Icons.local_fire_department,
      color: const Color(0xFFFF6D00),
      title: 'Calorie Goal Reached',
      message: 'You\'ve burned 500 calories today. Amazing progress!',
      time: '15 min ago',
      isUnread: true,
      category: _NotifCategory.achievement,
    ),
    _NotificationItem(
      icon: Icons.emoji_events,
      color: const Color(0xFFFFD600),
      title: 'New Achievement Unlocked',
      message: 'You completed 7 consecutive days of workouts!',
      time: '1 hr ago',
      isUnread: true,
      category: _NotifCategory.achievement,
    ),
    _NotificationItem(
      icon: Icons.schedule,
      color: const Color(0xFF2979FF),
      title: 'Workout Reminder',
      message: 'Your leg day session starts in 30 minutes.',
      time: '2 hrs ago',
      isUnread: false,
      category: _NotifCategory.reminder,
    ),
    _NotificationItem(
      icon: Icons.trending_up,
      color: const Color(0xFF00BFA5),
      title: 'Weekly Progress',
      message: 'You\'re 20% ahead of last week\'s activity. Keep going!',
      time: '5 hrs ago',
      isUnread: false,
      category: _NotifCategory.progress,
    ),
    _NotificationItem(
      icon: Icons.water_drop,
      color: const Color(0xFF29B6F6),
      title: 'Hydration Reminder',
      message: 'Don\'t forget to drink water. Stay hydrated!',
      time: '6 hrs ago',
      isUnread: false,
      category: _NotifCategory.reminder,
    ),
    _NotificationItem(
      icon: Icons.directions_run,
      color: const Color(0xFFE91E63),
      title: 'New Workout Available',
      message: 'Try the new HIIT Cardio Blast routine added today.',
      time: 'Yesterday',
      isUnread: false,
      category: _NotifCategory.workout,
    ),
    _NotificationItem(
      icon: Icons.star,
      color: const Color(0xFFFF9800),
      title: 'Personal Best!',
      message: 'You set a new record on the plank — 2 min 30 sec!',
      time: 'Yesterday',
      isUnread: false,
      category: _NotifCategory.achievement,
    ),
    _NotificationItem(
      icon: Icons.nightlight_round,
      color: const Color(0xFF7E57C2),
      title: 'Rest Day Tomorrow',
      message: 'Recovery is key. Take it easy and let your muscles heal.',
      time: '2 days ago',
      isUnread: false,
      category: _NotifCategory.reminder,
    ),
  ];

  _NotifCategory _selectedFilter = _NotifCategory.all;

  List<_NotificationItem> get _filteredNotifications {
    if (_selectedFilter == _NotifCategory.all) return _notifications;
    return _notifications.where((n) => n.category == _selectedFilter).toList();
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isUnread = false;
      }
    });
  }

  void _dismissNotification(int index) {
    final filtered = _filteredNotifications;
    final item = filtered[index];
    setState(() {
      _notifications.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${item.title}" dismissed'),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _notifications.insert(
                _notifications.length > index ? index : _notifications.length,
                item,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredNotifications;

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
          if (_unreadCount > 0)
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
      body: Column(
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
                    onSelected: (_) => setState(() => _selectedFilter = cat),
                    selectedColor: Colors.deepPurple.withValues(alpha: 0.15),
                    checkmarkColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.deepPurple
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        key: ValueKey(notif.hashCode),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _dismissNotification(index),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.15),
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
  }

  Widget _buildNotificationTile(_NotificationItem notif, bool isDark) {
    return Container(
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
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
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
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  bool isUnread;
  final _NotifCategory category;

  _NotificationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.category,
  });
}
