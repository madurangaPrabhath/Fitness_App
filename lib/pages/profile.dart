import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/services/database.dart';
import 'package:fitness_app/services/shared_pref.dart';
import 'package:fitness_app/pages/signin.dart';
import 'package:fitness_app/pages/editprofile.dart';
import 'package:fitness_app/pages/notifications.dart';
import 'package:fitness_app/pages/settings.dart';
import 'package:fitness_app/pages/helpsupport.dart';
import 'package:fitness_app/pages/about.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _db = DatabaseMethods();
  final _prefs = SharedPreferenceMethods();
  String? _uid;
  bool _isLoggingOut = false;

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

    if (!mounted) return;

    if (uid == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false,
      );
      return;
    }

    setState(() => _uid = uid);
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await FirebaseAuth.instance.signOut();
      await _prefs.clearUserSession();
    } catch (_) {}
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
      (route) => false,
    );
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
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Failed to load profile.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final data = (snapshot.data?.data() as Map<String, dynamic>?) ?? {};
            final name = (data['name'] as String?)?.isNotEmpty == true
                ? data['name'] as String
                : (FirebaseAuth.instance.currentUser?.displayName ?? 'User');
            final email = (data['email'] as String?)?.isNotEmpty == true
                ? data['email'] as String
                : (FirebaseAuth.instance.currentUser?.email ?? '');
            final photoUrl = data['photoUrl'] as String?;
            final workouts = data['totalWorkouts'] ?? 0;
            final calories = data['totalCalories'] ?? 0;
            final minutes = data['totalMinutes'] ?? 0;

            final heightCm = (data['heightCm'] as num?)?.toDouble();
            final weightKg = (data['weightKg'] as num?)?.toDouble();
            final dobStr = data['dob'] as String?;
            int? age;
            if (dobStr != null && dobStr.isNotEmpty) {
              try {
                final dob = DateTime.parse(dobStr);
                final now = DateTime.now();
                age = now.year - dob.year;
                if (now.month < dob.month ||
                    (now.month == dob.month && now.day < dob.day)) {
                  age--;
                }
              } catch (_) {}
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.deepPurple.withValues(alpha: 0.15),
                    backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl)
                        : null,
                    child: photoUrl == null || photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 52,
                            color: Colors.deepPurple,
                          )
                        : null,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  if (age != null || heightCm != null || weightKg != null) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        if (age != null)
                          _InfoChip(
                            icon: Icons.cake_outlined,
                            label: '$age yrs',
                          ),
                        if (heightCm != null)
                          _InfoChip(
                            icon: Icons.height,
                            label: '${heightCm.round()} cm',
                          ),
                        if (weightKg != null)
                          _InfoChip(
                            icon: Icons.monitor_weight_outlined,
                            label: '${weightKg.round()} kg',
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(label: 'Workouts', value: '$workouts'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          label: 'Calories',
                          value: _formatNumber(calories),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          label: 'Minutes',
                          value: _formatNumber(minutes),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                    child: _buildOption(Icons.person_outline, 'Edit Profile'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsPage(),
                        ),
                      );
                    },
                    child: _buildOption(
                      Icons.notifications_outlined,
                      'Notifications',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                    child: _buildOption(Icons.settings_outlined, 'Settings'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportPage(),
                        ),
                      );
                    },
                    child: _buildOption(Icons.help_outline, 'Help & Support'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                    child: _buildOption(Icons.info_outline, 'About'),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoggingOut ? null : _logout,
                      icon: _isLoggingOut
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    final n = (value is int) ? value : (value as num?)?.toInt() ?? 0;
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return '$n';
  }

  static Widget _buildOption(IconData icon, String title) {
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2a2a3d) : Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.deepPurple),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
