import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'FitLife',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildCard(
              isDark: isDark,
              child: const Text(
                'FitLife is your personal fitness companion designed to help you '
                'track workouts, monitor progress, and achieve your health goals. '
                'Built with love for fitness enthusiasts of all levels.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),

            const SizedBox(height: 20),

            _sectionHeader('Key Features'),
            const SizedBox(height: 10),

            _buildFeatureRow(const [
              _FeatureItem(
                icon: Icons.fitness_center,
                label: 'Workouts',
                color: Color(0xFF7C4DFF),
              ),
              _FeatureItem(
                icon: Icons.local_fire_department,
                label: 'Calorie Tracking',
                color: Color(0xFFFF6D00),
              ),
            ], isDark),
            const SizedBox(height: 10),
            _buildFeatureRow(const [
              _FeatureItem(
                icon: Icons.trending_up,
                label: 'Progress Stats',
                color: Color(0xFF00BFA5),
              ),
              _FeatureItem(
                icon: Icons.person_outline,
                label: 'Body Tracking',
                color: Color(0xFF2979FF),
              ),
            ], isDark),
            const SizedBox(height: 10),
            _buildFeatureRow(const [
              _FeatureItem(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                color: Color(0xFF7E57C2),
              ),
              _FeatureItem(
                icon: Icons.notifications_outlined,
                label: 'Reminders',
                color: Color(0xFFE91E63),
              ),
            ], isDark),

            const SizedBox(height: 24),

            _sectionHeader('Developer'),
            const SizedBox(height: 10),

            _buildCard(
              isDark: isDark,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.code,
                      color: Colors.deepPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _launchUrl(),
                          child: const Text(
                            'Maduranga Prabhath',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Built with Flutter & Dart',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionHeader('Tech Stack'),
            const SizedBox(height: 10),

            _buildInfoTile(
              icon: Icons.flutter_dash,
              title: 'Flutter',
              subtitle: 'Cross-platform UI framework',
              color: const Color(0xFF027DFD),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildInfoTile(
              icon: Icons.data_object,
              title: 'Dart',
              subtitle: 'Programming language',
              color: const Color(0xFF00BFA5),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildInfoTile(
              icon: Icons.style_outlined,
              title: 'Material Design 3',
              subtitle: 'Modern design system',
              color: const Color(0xFF7C4DFF),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildInfoTile(
              icon: Icons.sync_alt,
              title: 'Provider',
              subtitle: 'State management',
              color: const Color(0xFFFF6D00),
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _sectionHeader('Legal'),
            const SizedBox(height: 10),

            _buildActionTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              isDark: isDark,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              isDark: isDark,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.gavel_outlined,
              title: 'Open Source Licenses',
              isDark: isDark,
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'FitLife',
                applicationVersion: '1.0.0',
                applicationIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              '© 2026 FitLife. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => _launchUrl(),
              child: Text.rich(
                TextSpan(
                  text: 'Made with ♥ by ',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  children: const [
                    TextSpan(
                      text: 'Maduranga Prabhath',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildCard({required bool isDark, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _buildFeatureRow(List<_FeatureItem> items, bool isDark) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: items.indexOf(item) == 0 ? 5 : 0,
              left: items.indexOf(item) == 1 ? 5 : 0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchUrl() async {
    final uri = Uri.parse('https://madurangaprabhath.vercel.app/');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}
