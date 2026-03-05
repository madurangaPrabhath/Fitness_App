import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/exercise/exercise_detail.dart';

class _ArmExercise {
  final String name;
  final String sets;
  final String time;
  final String imagePath;

  const _ArmExercise({
    required this.name,
    required this.sets,
    required this.time,
    required this.imagePath,
  });
}

const List<_ArmExercise> _exercises = [
  _ArmExercise(
    name: 'Bicep Curls',
    sets: '3 sets | 12 repetition',
    time: '10:00',
    imagePath: 'images/fit1.png',
  ),
  _ArmExercise(
    name: 'Tricep Dips',
    sets: '3 sets | 15 repetition',
    time: '08:00',
    imagePath: 'images/fit2.png',
  ),
  _ArmExercise(
    name: 'Shoulder Press',
    sets: '3 sets | 12 repetition',
    time: '10:00',
    imagePath: 'images/shoulder-stretch.jpg',
  ),
  _ArmExercise(
    name: 'Lateral Raises',
    sets: '3 sets | 15 repetition',
    time: '08:00',
    imagePath: 'images/fit3.png',
  ),
  _ArmExercise(
    name: 'Push-Ups',
    sets: '3 sets | 15 repetition',
    time: '09:00',
    imagePath: 'images/girl.jpg',
  ),
  _ArmExercise(
    name: 'Hammer Curls',
    sets: '3 sets | 12 repetition',
    time: '07:00',
    imagePath: 'images/fit1.png',
  ),
];

class ArmPage extends StatelessWidget {
  const ArmPage({super.key});

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
            'Arm Workout',
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
                CupertinoIcons.chevron_left,
                color: Color(0xFF2979FF),
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
  final _ArmExercise exercise;

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
              '12',
        ) ??
        12;
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
              color: const Color(0xFF2979FF).withValues(alpha: 0.07),
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
              _ExerciseThumbnail(imagePath: exercise.imagePath),
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
        color: isDark ? const Color(0xFF1A2E5A) : const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.bolt_fill,
            size: 13,
            color: Color(0xFF2979FF),
          ),
          const SizedBox(width: 5),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2979FF),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseThumbnail extends StatelessWidget {
  final String imagePath;

  const _ExerciseThumbnail({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1A2E5A)
                : const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            CupertinoIcons.bolt_fill,
            color: Color(0xFF2979FF),
            size: 32,
          ),
        ),
      ),
    );
  }
}
