import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/services/database.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _db = DatabaseMethods();
  String? _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  String _formatDate(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate().toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Color _colorForWorkout(String name) {
    const palette = [
      Color(0xFF7C4DFF),
      Color(0xFFFF6D00),
      Color(0xFF00BFA5),
      Color(0xFF2979FF),
      Color(0xFFE91E63),
      Color(0xFF00C853),
    ];
    return palette[name.hashCode.abs() % palette.length];
  }

  IconData _iconForWorkout(String name) {
    final n = name.toLowerCase();
    if (n.contains('push') || n.contains('dip') || n.contains('press')) {
      return Icons.sports_gymnastics;
    }
    if (n.contains('run') || n.contains('jump') || n.contains('cardio')) {
      return Icons.directions_run;
    }
    if (n.contains('stretch') || n.contains('yoga') || n.contains('plank')) {
      return Icons.self_improvement;
    }
    if (n.contains('walk') || n.contains('lunge')) {
      return Icons.directions_walk;
    }
    return Icons.fitness_center;
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Progress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _db.userStream(_uid!),
        builder: (context, userSnap) {
          final userData =
              (userSnap.data?.data() as Map<String, dynamic>?) ?? {};
          final totalWorkouts = userData['totalWorkouts'] ?? 0;
          final totalCalories = userData['totalCalories'] ?? 0;
          final totalMinutes = userData['totalMinutes'] ?? 0;

          return StreamBuilder<QuerySnapshot>(
            stream: _db.getWorkoutLogsStream(_uid!),
            builder: (context, logsSnap) {
              final logs = logsSnap.data?.docs ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Workouts',
                            value: '$totalWorkouts',
                            icon: Icons.check_circle_outline,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Calories',
                            value: totalCalories >= 1000
                                ? '${(totalCalories / 1000).toStringAsFixed(1)}k'
                                : '$totalCalories',
                            icon: Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Minutes',
                            value: totalMinutes >= 1000
                                ? '${(totalMinutes / 1000).toStringAsFixed(1)}k'
                                : '$totalMinutes',
                            icon: Icons.timer_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    if (logs.isNotEmpty) ...[
                      const Text(
                        'Weekly Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _WeeklyActivity(logs: logs),
                      const SizedBox(height: 28),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Workout History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${logs.length} total',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (logsSnap.connectionState == ConnectionState.waiting)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (logs.isEmpty)
                      _EmptyState()
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: logs.length,
                        itemBuilder: (context, i) {
                          final d =
                              logs[i].data() as Map<String, dynamic>? ?? {};
                          final name = (d['name'] as String?) ?? 'Workout';
                          final sets = d['sets'] ?? 0;
                          final reps = d['reps'] ?? 0;
                          final calories = d['calories'] ?? 0;
                          final minutes = d['minutes'] ?? 0;
                          final durationSec =
                              (d['durationSeconds'] as int?) ?? 0;
                          final completedAt = d['completedAt'] as Timestamp?;
                          final color = _colorForWorkout(name);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _iconForWorkout(name),
                                    color: color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$sets sets · $reps reps · ${durationSec > 0 ? _formatDuration(durationSec) : '$minutes min'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 90,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.local_fire_department,
                                            color: Colors.orange,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 2),
                                          Flexible(
                                            child: Text(
                                              '$calories kcal',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(completedAt),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _WeeklyActivity extends StatelessWidget {
  final List<QueryDocumentSnapshot> logs;

  const _WeeklyActivity({required this.logs});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final dayCounts = List<int>.filled(7, 0);
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    for (final log in logs) {
      final d = log.data() as Map<String, dynamic>? ?? {};
      final ts = d['completedAt'] as Timestamp?;
      if (ts == null) continue;
      final dt = ts.toDate().toLocal();
      final diff = dt
          .difference(DateTime(weekStart.year, weekStart.month, weekStart.day))
          .inDays;
      if (diff >= 0 && diff < 7) {
        dayCounts[diff]++;
      }
    }

    final maxCount = dayCounts.reduce((a, b) => a > b ? a : b);
    final todayIndex = now.weekday - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                '${dayCounts.reduce((a, b) => a + b)} workouts',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final count = dayCounts[i];
                final ratio = maxCount == 0 ? 0.0 : count / maxCount;
                final isToday = i == todayIndex;
                final barColor = isToday
                    ? Colors.deepPurple
                    : Colors.deepPurple.withValues(alpha: 0.35);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (count > 0)
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: barColor,
                        ),
                      ),
                    const SizedBox(height: 3),
                    Container(
                      width: 28,
                      height: ratio == 0 ? 4 : (ratio * 44).clamp(4.0, 44.0),
                      decoration: BoxDecoration(
                        color: ratio == 0
                            ? Colors.grey.withValues(alpha: 0.2)
                            : barColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dayLabels[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isToday ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 48,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No workouts yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete a workout to see your progress here.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
