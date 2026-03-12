import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/services/database.dart';
import 'package:fitness_app/services/support_widget.dart';
import 'package:fitness_app/exercise/cardio_page.dart';
import 'package:fitness_app/exercise/arm_page.dart';
import 'package:fitness_app/exercise/stretching_page.dart';
import 'package:fitness_app/exercise/exercise_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = DatabaseMethods();
  String? _uid;

  @override
  void initState() {
    super.initState();
    _resolveUid();
  }

  Future<void> _resolveUid() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      try {
        final user = await FirebaseAuth.instance.authStateChanges().first;
        uid = user?.uid;
      } catch (_) {}
    }
    if (mounted) setState(() => _uid = uid);
  }

  String _formatNumber(dynamic value) {
    final n = (value is int) ? value : (value as num?)?.toInt() ?? 0;
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _db.userStream(_uid!),
          builder: (context, snapshot) {
            final data = (snapshot.data?.data() as Map<String, dynamic>?) ?? {};

            final firstName =
                ((data['name'] as String?)?.isNotEmpty == true
                        ? data['name'] as String
                        : FirebaseAuth.instance.currentUser?.displayName ?? '')
                    .split(' ')
                    .first;
            final greeting = firstName.isNotEmpty
                ? 'Hi, $firstName 👋'
                : 'Hi there 👋';

            final workouts = data['totalWorkouts'] ?? 0;
            final calories = data['totalCalories'] ?? 0;
            final minutes = data['totalMinutes'] ?? 0;

            final photoPath = data['photoPath'] as String?;
            final photoFile = (photoPath != null && photoPath.isNotEmpty)
                ? File(photoPath)
                : null;
            final validPhoto = (photoFile != null && photoFile.existsSync())
                ? photoFile
                : null;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Let's check your activity",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.deepPurple.withValues(
                            alpha: 0.15,
                          ),
                          backgroundImage: photoProvider,
                          child: photoProvider == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                  size: 28,
                                )
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      height: 160,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset('images/girl.jpg', fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 16,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stay Consistent!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Your body achieves what your mind believes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: 'Workouts',
                            value: '$workouts',
                            subtitle: 'Completed',
                            icon: Icons.check_circle,
                            iconColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: InfoCard(
                            title: 'Calories',
                            value: _formatNumber(calories),
                            subtitle: 'Burned',
                            icon: Icons.local_fire_department,
                            iconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    InfoCard(
                      title: 'Time Spent',
                      value: _formatNumber(minutes),
                      subtitle: 'Minutes',
                      icon: Icons.timer,
                      iconColor: Colors.blue,
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Discover new workouts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => const CardioPage(),
                              ),
                            ),
                            child: CategoryCard(
                              title: 'Cardio',
                              subtitle: '6 Exercises\n100 Minutes',
                              color: Colors.orange,
                              image: 'images/fit1.png',
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => const ArmPage(),
                              ),
                            ),
                            child: CategoryCard(
                              title: 'Arm',
                              subtitle: '6 Exercises\n100 Minutes',
                              color: Colors.teal,
                              image: 'images/fit2.png',
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => const StretchingPage(),
                              ),
                            ),
                            child: CategoryCard(
                              title: 'Stretching',
                              subtitle: '8 Exercises\n120 Minutes',
                              color: Colors.blue,
                              image: 'images/fit3.png',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Top Workouts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExerciseDetailPage(
                            name: 'Squats',
                            imagePath: 'images/fit1.png',
                            duration: '10:00',
                            sets: 2,
                            defaultReps: 10,
                          ),
                        ),
                      ),
                      child: const WorkoutCard(
                        title: 'Squats',
                        details: '2 sets | 10 Repetition',
                        time: '10:00',
                        icon: Icons.fitness_center,
                        iconColor: Color(0xFF7C4DFF),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExerciseDetailPage(
                            name: 'Push-Ups',
                            imagePath: 'images/girl.jpg',
                            duration: '08:00',
                            sets: 3,
                            defaultReps: 15,
                          ),
                        ),
                      ),
                      child: const WorkoutCard(
                        title: 'Push Ups',
                        details: '3 sets | 15 Repetition',
                        time: '08:00',
                        icon: Icons.sports_gymnastics,
                        iconColor: Color(0xFFFF6D00),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExerciseDetailPage(
                            name: 'Lunges',
                            imagePath: 'images/fit2.png',
                            duration: '12:00',
                            sets: 3,
                            defaultReps: 12,
                          ),
                        ),
                      ),
                      child: const WorkoutCard(
                        title: 'Lunges',
                        details: '3 sets | 12 Repetition',
                        time: '12:00',
                        icon: Icons.directions_walk,
                        iconColor: Color(0xFF00BFA5),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
