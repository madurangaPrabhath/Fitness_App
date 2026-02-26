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
              onTap: () => _showTermsOfService(context),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              isDark: isDark,
              onTap: () => _showPrivacyPolicy(context),
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

  static void _showTermsOfService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1e1e2e) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: Colors.deepPurple,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      children: [
                        _tosText(
                          'Last updated: February 26, 2026',
                          isDark,
                          isDate: true,
                        ),
                        const SizedBox(height: 16),
                        _tosText(
                          'Welcome to FitLife. By downloading, installing, or using this application, '
                          'you agree to be bound by these Terms of Service. Please read them carefully.',
                          isDark,
                        ),
                        const SizedBox(height: 20),
                        _tosSection('1. Acceptance of Terms', isDark),
                        _tosText(
                          'By accessing or using FitLife, you confirm that you are at least 13 years of age '
                          'and agree to comply with these Terms. If you do not agree, please discontinue '
                          'use of the application immediately.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('2. Health & Safety Disclaimer', isDark),
                        _tosText(
                          'FitLife provides fitness guidance for informational purposes only and does not '
                          'constitute medical advice. Before beginning any exercise programme, consult a '
                          'qualified healthcare professional, especially if you have pre-existing medical '
                          'conditions, injuries, or concerns about your physical health. You assume full '
                          'responsibility for any risks associated with physical activity.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('3. User Account & Profile Data', isDark),
                        _tosText(
                          'You are responsible for maintaining the accuracy of your profile information '
                          '(name, age, height, weight, etc.). This data is used solely to personalise '
                          'your fitness experience, such as estimating calorie burn. You must keep your '
                          'account credentials secure and notify us promptly of any unauthorised access.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('4. Acceptable Use', isDark),
                        _tosText(
                          'You agree not to:\n'
                          '• Misuse the app for any unlawful or harmful purpose.\n'
                          '• Attempt to reverse-engineer, decompile, or tamper with the application.\n'
                          '• Upload offensive, abusive, or misleading content.\n'
                          '• Interfere with the normal operation of the app or its servers.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection(
                          '5. Workout & Calorie Data Accuracy',
                          isDark,
                        ),
                        _tosText(
                          'Calorie estimates and workout metrics provided by FitLife are approximations '
                          'based on general algorithms and the profile data you supply. They are intended '
                          'as a guide only and may not reflect your actual physiological response. '
                          'Do not make significant dietary or medical decisions based solely on '
                          'in-app figures.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('6. Intellectual Property', isDark),
                        _tosText(
                          'All content within FitLife, including workout routines, graphics, icons, and '
                          'code, is the intellectual property of FitLife and its developer. You may not '
                          'reproduce, distribute, or create derivative works without prior written consent.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('7. Privacy', isDark),
                        _tosText(
                          'Your use of FitLife is also governed by our Privacy Policy, which describes '
                          'how we collect, store, and protect your personal information. By using the app '
                          'you consent to those practices.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('8. Limitation of Liability', isDark),
                        _tosText(
                          'To the fullest extent permitted by law, FitLife and its developer shall not '
                          'be liable for any direct, indirect, incidental, or consequential damages '
                          'arising from your use of the app, including but not limited to injury, '
                          'data loss, or inaccurate fitness metrics.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('9. Changes to These Terms', isDark),
                        _tosText(
                          'We reserve the right to update these Terms at any time. Continued use of '
                          'FitLife after changes are posted constitutes acceptance of the revised Terms. '
                          'We encourage you to review this section periodically.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('10. Contact Us', isDark),
                        _tosText(
                          'If you have any questions about these Terms of Service, please contact us at:\n'
                          'support@fitlife.app',
                          isDark,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _tosSection(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  static Widget _tosText(String text, bool isDark, {bool isDate = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isDate ? 12 : 13,
        height: 1.6,
        color: isDate
            ? Colors.grey
            : (isDark ? Colors.white70 : Colors.grey.shade700),
        fontStyle: isDate ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  static void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1e1e2e) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.privacy_tip_outlined,
                          color: Colors.deepPurple,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      children: [
                        _tosText(
                          'Last updated: February 26, 2026',
                          isDark,
                          isDate: true,
                        ),
                        const SizedBox(height: 16),
                        _tosText(
                          'FitLife ("we", "our", or "the app") is committed to protecting your '
                          'personal information. This Privacy Policy explains what data we collect, '
                          'how we use it, and the choices you have regarding your information.',
                          isDark,
                        ),
                        const SizedBox(height: 20),
                        _tosSection('1. Information We Collect', isDark),
                        _tosText(
                          'We collect information you provide directly when you create or update your profile:\n'
                          '• Personal details: name, email address, phone number, date of birth, and gender.\n'
                          '• Body metrics: height and weight, used to personalise calorie and workout estimates.\n'
                          '• Profile photo: optionally uploaded by you.\n'
                          '• Activity data: workouts completed, calories burned, and active minutes recorded within the app.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('2. How We Use Your Information', isDark),
                        _tosText(
                          'Your data is used exclusively to:\n'
                          '• Personalise your fitness experience and calculate workout metrics.\n'
                          '• Display your progress on the Home and Profile screens.\n'
                          '• Send workout reminders, goal alerts, and hydration notifications (only if enabled by you).\n'
                          '• Improve app performance and fix bugs through anonymised usage patterns.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('3. Data Storage', isDark),
                        _tosText(
                          'All profile and activity data is stored locally on your device. We do not '
                          'transmit your personal information to external servers unless you explicitly '
                          'use a feature that requires it (such as cloud backup, if available in a '
                          'future update). You are in full control of the data on your device.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('4. Data Sharing', isDark),
                        _tosText(
                          'We do not sell, rent, or share your personal information with third parties. '
                          'We will only disclose your information if required to do so by law or in '
                          'response to a valid legal request from a competent authority.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('5. Notifications', isDark),
                        _tosText(
                          'FitLife may send local push notifications for workout reminders, goal alerts, '
                          'hydration reminders, and weekly progress reports. You can enable or disable '
                          'each notification type at any time in Profile → Settings → Notifications, '
                          'or through your device\'s system notification settings.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('6. Permissions', isDark),
                        _tosText(
                          'FitLife may request the following device permissions:\n'
                          '• Camera & Photo Library: to set or update your profile picture.\n'
                          '• Notifications: to send fitness reminders and alerts.\n'
                          'Permissions are only requested when needed and can be revoked at any time '
                          'through your device settings.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('7. Children\'s Privacy', isDark),
                        _tosText(
                          'FitLife is not intended for children under the age of 13. We do not knowingly '
                          'collect personal information from children. If you believe a child has '
                          'provided us with personal data, please contact us so we can take appropriate action.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('8. Your Rights', isDark),
                        _tosText(
                          'You have the right to:\n'
                          '• Access and review the personal data stored in your profile at any time.\n'
                          '• Edit or update your information via Profile → Edit Profile.\n'
                          '• Delete your account and all associated data from within the app settings.\n'
                          'Because data is stored locally, uninstalling the app will remove all '
                          'app data from your device.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('9. Security', isDark),
                        _tosText(
                          'We follow industry best practices to protect the data stored on your device. '
                          'However, no method of electronic storage is 100% secure. We encourage you '
                          'to use a strong device passcode and keep your operating system up to date.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('10. Changes to This Policy', isDark),
                        _tosText(
                          'We may update this Privacy Policy from time to time. Any changes will be '
                          'reflected with an updated date at the top of this page. Continued use of '
                          'FitLife after changes are posted constitutes your acceptance of the '
                          'revised policy.',
                          isDark,
                        ),
                        const SizedBox(height: 16),
                        _tosSection('11. Contact Us', isDark),
                        _tosText(
                          'If you have any questions or concerns about this Privacy Policy, '
                          'please contact us at:\n'
                          'support@fitlife.app',
                          isDark,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
