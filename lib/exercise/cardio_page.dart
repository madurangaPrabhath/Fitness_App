import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/exercise/exercise_detail.dart';

class _CardioExercise {
  final String name;
  final String sets;
  final String time;
  final String imagePath;
  final IconData icon;
  final Color iconColor;

  const _CardioExercise({
    required this.name,
    required this.sets,
    required this.time,
    required this.imagePath,
    required this.icon,
    required this.iconColor,
  });
}

const List<_CardioExercise> _exercises = [
  _CardioExercise(
    name: 'Jump Rope',
    sets: '3 sets | 30 repetition',
    time: '10:00',
    imagePath: 'images/fit1.png',
    icon: Icons.directions_run,
    iconColor: Color(0xFF2979FF),
  ),
  _CardioExercise(
    name: 'High Knees',
    sets: '3 sets | 20 repetition',
    time: '08:00',
    imagePath: 'images/fit2.png',
    icon: Icons.directions_walk,
    iconColor: Color(0xFF00BFA5),
  ),
  _CardioExercise(
    name: 'Burpees',
    sets: '3 sets | 10 repetition',
    time: '12:00',
    imagePath: 'images/fit3.png',
    icon: Icons.local_fire_department,
    iconColor: Color(0xFFFF3D00),
  ),
  _CardioExercise(
    name: 'Jumping Jacks',
    sets: '3 sets | 20 repetition',
    time: '06:00',
    imagePath: 'images/girl.jpg',
    icon: Icons.sports,
    iconColor: Color(0xFF7C4DFF),
  ),
  _CardioExercise(
    name: 'Mountain Climbers',
    sets: '3 sets | 20 repetition',
    time: '07:00',
    imagePath: 'images/fit1.png',
    icon: Icons.terrain,
    iconColor: Color(0xFF6D4C41),
  ),
  _CardioExercise(
    name: 'Box Jumps',
    sets: '3 sets | 15 repetition',
    time: '09:00',
    imagePath: 'images/fit2.png',
    icon: Icons.sports_gymnastics,
    iconColor: Color(0xFFFF6D00),
  ),
];

class CardioPage extends StatelessWidget {
  const CardioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E1E2C)
          : const Color(0xFFF4F4F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopNavBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                itemCount: _exercises.length,
                itemBuilder: (context, index) =>
                    _ExerciseCard(exercise: _exercises[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Cardio',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF1A1A2E),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFFF6B35),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final _CardioExercise exercise;

  const _ExerciseCard({required this.exercise});

  static (int sets, int reps) _parseSetsReps(String raw) {
    final parts = raw.split('|');
    final sets =
        int.tryParse(
          RegExp(r'\d+').firstMatch(parts.elementAtOrNull(0) ?? '')?.group(0) ??
              '3',
        ) ??
        3;
    final reps =
        int.tryParse(
          RegExp(r'\d+').firstMatch(parts.elementAtOrNull(1) ?? '')?.group(0) ??
              '20',
        ) ??
        20;
    return (sets, reps);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (sets, reps) = _parseSetsReps(exercise.sets);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ExerciseDetailPage(
            name: exercise.name,
            imagePath: exercise.imagePath,
            duration: exercise.time,
            sets: sets,
            defaultReps: reps,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A3D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.07),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.sets,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8E8EA0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _TimeBadge(time: exercise.time),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _ExerciseThumbnail(
                icon: exercise.icon,
                iconColor: exercise.iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  final String time;

  const _TimeBadge({required this.time});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D2210) : const Color(0xFFFFEEE8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            size: 13,
            color: Color(0xFFFF6B35),
          ),
          const SizedBox(width: 5),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B35),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseThumbnail extends StatelessWidget {
  final IconData icon;
  final Color iconColor;

  const _ExerciseThumbnail({required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: iconColor, size: 32),
    );
  }
}
