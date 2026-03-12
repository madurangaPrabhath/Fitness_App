import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/services/database.dart';

class ExerciseDetailPage extends StatefulWidget {
  final String name;
  final String imagePath;

  final String duration;

  final int sets;

  final int defaultReps;

  final String? description;

  const ExerciseDetailPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.duration,
    this.sets = 2,
    this.defaultReps = 20,
    this.description,
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage>
    with TickerProviderStateMixin {
  late final int _totalSeconds;
  late int _remaining;
  bool _isRunning = false;
  Timer? _ticker;

  late final AnimationController _ringController;

  int _completedSets = 0;
  late int _reps;
  bool _workoutSaved = false;

  final _db = DatabaseMethods();

  static const Color _timerOrange = Color(0xFFFF6B35);

  @override
  void initState() {
    super.initState();
    _totalSeconds = _parseSeconds(widget.duration);
    _remaining = _totalSeconds;
    _reps = widget.defaultReps;

    _ringController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ringController.dispose();
    super.dispose();
  }

  static int _parseSeconds(String mmss) {
    final parts = mmss.split(':');
    if (parts.length != 2) return 0;
    final m = int.tryParse(parts[0]) ?? 0;
    final s = int.tryParse(parts[1]) ?? 0;
    return m * 60 + s;
  }

  String get _displayTime {
    final m = _remaining ~/ 60;
    final s = _remaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      _totalSeconds == 0 ? 0 : 1 - (_remaining / _totalSeconds);

  void _toggleTimer() {
    if (_isRunning) {
      _ticker?.cancel();
      _ringController.stop();
    } else {
      if (_remaining == 0) _resetTimer();
      _ringController.forward(
        from: _totalSeconds == 0 ? 0 : 1 - (_remaining / _totalSeconds),
      );
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remaining <= 0) {
          _stopTimer();
          _onTimerFinished();
        } else {
          setState(() => _remaining--);
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ringController.stop();
    if (mounted) setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _ticker?.cancel();
    _ringController.reset();
    setState(() {
      _remaining = _totalSeconds;
      _isRunning = false;
    });
  }

  void _onTimerFinished() {
    setState(() => _completedSets++);
    if (_completedSets >= widget.sets) {
      _onWorkoutComplete();
    } else {
      _showSetCompleteSnack();
    }
  }

  Future<void> _onWorkoutComplete() async {
    if (_workoutSaved) return;
    _workoutSaved = true;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final totalMinutes = ((_totalSeconds * widget.sets) / 60).ceil().clamp(
      1,
      9999,
    );
    final calories = (_kcalForWorkout(
      widget.name,
      totalMinutes,
    )).clamp(1, 9999);

    if (uid != null) {
      try {
        await _db.incrementStats(
          uid: uid,
          calories: calories,
          minutes: totalMinutes,
        );
        await _db.addWorkout(uid, {
          'name': widget.name,
          'sets': widget.sets,
          'reps': _reps,
          'durationSeconds': _totalSeconds * widget.sets,
          'calories': calories,
          'minutes': totalMinutes,
        });
        await _db.addNotification(uid, {
          'title': 'Workout Complete 💪',
          'message':
              'Great job! You finished ${widget.name} — '
              '${widget.sets} sets, $_reps reps, '
              '$totalMinutes min, $calories kcal burned.',
          'category': 'workout',
          'iconCodePoint': Icons.fitness_center.codePoint,
          'colorValue': Colors.deepPurple.toARGB32(),
          'isRead': false,
        });
      } catch (_) {}
    }

    if (!mounted) return;
    _showWorkoutCompleteDialog();
  }

  /// Returns estimated calories burned for [name] given [minutes] of work.
  /// Rates (kcal/min) are based on MET values for a ~70 kg person.
  static int _kcalForWorkout(String name, int minutes) {
    // kcal/min per exercise (MET × 70 kg × 1/60 hr)
    const rates = <String, double>{
      // Cardio
      'Jump Rope': 12.0,
      'Burpees': 10.0,
      'High Knees': 9.0,
      'Mountain Climbers': 9.0,
      'Box Jumps': 9.5,
      'Jumping Jacks': 8.0,
      // Strength
      'Squats': 6.5,
      'Lunges': 6.0,
      'Deadlifts': 7.0,
      'Push-Ups': 7.0,
      'Plank': 3.5,
      'Bicep Curls': 4.5,
      'Tricep Dips': 5.0,
      'Shoulder Press': 5.5,
      'Lateral Raises': 4.5,
      'Hammer Curls': 4.5,
      // Stretching
      'Calf Stretch': 2.5,
      'Cat-Cow Stretch': 2.5,
      'Shoulder Stretch': 2.5,
      'Chest Stretch': 2.5,
      'Hamstring Stretch': 2.5,
    };
    final rate = rates[name] ?? 6.0; // default: moderate resistance
    return (minutes * rate).round();
  }

  void _showWorkoutCompleteDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.deepPurple,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Workout Complete!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Great job finishing ${widget.name}. Your stats have been updated.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).maybePop();
                },
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetCompleteSnack() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _timerOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Set complete! Great work 💪',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E1E2C)
          : const Color(0xFFF4F4F8),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroImage(
                imagePath: widget.imagePath,
                exerciseName: widget.name,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoSection(
                      name: widget.name,
                      description:
                          widget.description ??
                          _defaultDescription(widget.name),
                    ),
                    const SizedBox(height: 16),
                    _TimerCard(
                      progress: _progress,
                      displayTime: _displayTime,
                      isRunning: _isRunning,
                      onToggle: _toggleTimer,
                      onReset: _resetTimer,
                      ringController: _ringController,
                    ),
                    const SizedBox(height: 16),
                    _StatsRow(
                      completedSets: _completedSets,
                      totalSets: widget.sets,
                      reps: _reps,
                      onDecrement: () {
                        if (_reps > 1) setState(() => _reps--);
                      },
                      onIncrement: () => setState(() => _reps++),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _defaultDescription(String name) {
    const map = <String, String>{
      'Calf Stretch':
          'Stand facing a wall with one foot forward and one foot back. '
          'Keep your back leg straight and press your heel into the floor. '
          'Lean gently into the wall until you feel a stretch in your calf. '
          'Hold for 20–30 seconds and switch sides.',
      'Cat-Cow Stretch':
          'Start on all fours with your wrists under your shoulders and knees '
          'under your hips. Inhale as you drop your belly and lift your head '
          '(Cow), then exhale as you round your spine toward the ceiling (Cat). '
          'Move slowly and rhythmically to warm up the entire spine.',
      'Shoulder Stretch':
          'Bring one arm across your chest and gently pull it closer with the '
          'opposite hand until you feel a stretch in the rear of the shoulder. '
          'Keep your shoulders relaxed and avoid rotating your torso. '
          'Hold for 20 seconds then repeat on the other side.',
      'Chest Stretch':
          'Stand tall and interlace your fingers behind your back. Straighten '
          'your arms, squeeze your shoulder blades together and lift your chest. '
          'Hold the stretch for 20–30 seconds while breathing deeply. '
          'This opens the chest and counters rounded-shoulder posture.',
      'Hamstring Stretch':
          'Sit on the floor with both legs extended. Reach forward toward your '
          'toes, keeping your back as straight as possible. You should feel a '
          'deep stretch along the back of your thighs. Hold for 20–30 seconds '
          'and repeat 2–3 times per session.',
    };
    return map[name] ??
        'Perform this exercise with slow, controlled movements. '
            'Focus on breathing and maintaining proper form throughout each '
            'repetition. Rest briefly between sets to allow your muscles to recover.';
  }
}

class _HeroImage extends StatelessWidget {
  final String imagePath;
  final String exerciseName;

  const _HeroImage({required this.imagePath, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final imageHeight = (MediaQuery.of(context).size.height * 0.28).clamp(
      180.0,
      260.0,
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFEEECFF),
                child: const Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: imageHeight * 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.60),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              right: 60,
              child: Text(
                exerciseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: topPadding + 10,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF6C63FF),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String name;
  final String description;

  const _InfoSection({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.5,
            color: isDark ? const Color(0xFF9E9EB8) : const Color(0xFF6B6B80),
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _TimerCard extends StatelessWidget {
  final double progress;
  final String displayTime;
  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback onReset;
  final AnimationController ringController;

  const _TimerCard({
    required this.progress,
    required this.displayTime,
    required this.isRunning,
    required this.onToggle,
    required this.onReset,
    required this.ringController,
  });

  static const Color _orange = Color(0xFFFF6B35);
  static const Color _orangeLight = Color(0xFFFFF0EB);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workout Timer',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: onReset,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _orangeLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.replay, size: 13, color: _orange),
                      SizedBox(width: 4),
                      Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onToggle,
            child: SizedBox(
              width: 120,
              height: 120,
              child: AnimatedBuilder(
                animation: ringController,
                builder: (_, _) {
                  return CustomPaint(
                    painter: _RingPainter(progress: progress),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isRunning ? Icons.pause : Icons.play_arrow,
                              key: ValueKey(isRunning),
                              color: _orange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayTime,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isRunning ? 'Tap to pause' : 'Tap to start',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  const _RingPainter({required this.progress});

  static const Color _track = Color(0xFFF0EEE8);
  static const Color _fill = Color(0xFFFF6B35);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 8;
    const strokeWidth = 9.0;

    final trackPaint = Paint()
      ..color = _track
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = _fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _StatsRow extends StatelessWidget {
  final int completedSets;
  final int totalSets;
  final int reps;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _StatsRow({
    required this.completedSets,
    required this.totalSets,
    required this.reps,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _SetsCard(completed: completedSets, total: totalSets),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _RepsCard(
              reps: reps,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetsCard extends StatelessWidget {
  final int completed;
  final int total;

  const _SetsCard({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatLabel(label: 'Total Sets', icon: Icons.layers),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$completed',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF1A1A2E),
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 4),
                child: Text(
                  '/ $total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8EA0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            completed == 0
                ? 'Not started yet'
                : completed >= total
                ? 'All sets done! 🎉'
                : '$completed of $total complete',
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF8E8EA0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepsCard extends StatelessWidget {
  final int reps;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _RepsCard({
    required this.reps,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatLabel(label: 'Repetition Count', icon: Icons.repeat),
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CounterButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 52,
                  child: Center(
                    child: Text(
                      '$reps',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1A1A2E),
                        height: 1,
                      ),
                    ),
                  ),
                ),
                _CounterButton(
                  icon: Icons.add,
                  onTap: onIncrement,
                  filled: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'reps per set',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF8E8EA0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _CounterButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  static const Color _accent = Color(0xFF6C63FF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: filled ? _accent : const Color(0xFFEEECFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: filled ? Colors.white : _accent),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget child;

  const _StatCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A3D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8EA0),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
