import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<_FaqCategory> _faqCategories = [
    _FaqCategory(
      title: 'Getting Started',
      icon: Icons.rocket_launch_outlined,
      color: Color(0xFF7C4DFF),
      faqs: [
        _FaqItem(
          question: 'How do I create a workout plan?',
          answer:
              'Go to the Workout tab and tap "Start Workout" to choose from preset routines, or create a custom plan by selecting exercises, sets, and reps that suit your fitness level.',
        ),
        _FaqItem(
          question: 'Can I set daily fitness goals?',
          answer:
              'Yes! Navigate to your Profile and set targets for calories, workout duration, and step count. The app will track your progress throughout the day.',
        ),
        _FaqItem(
          question: 'How do I track my progress?',
          answer:
              'Your Home screen shows daily activity stats. For detailed history, check the stats cards on your profile page for workouts completed, calories burned, and total active minutes.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Workouts',
      icon: Icons.fitness_center,
      color: Color(0xFFFF6D00),
      faqs: [
        _FaqItem(
          question: 'What types of workouts are available?',
          answer:
              'We offer Squats, Push Ups, Lunges, Planks, Burpees, Jumping Jacks, and more. Each workout displays sets, repetitions, and estimated time to help you plan.',
        ),
        _FaqItem(
          question: 'Can I modify a workout routine?',
          answer:
              'Currently workouts follow preset configurations. Custom workout editing is planned for a future update. Stay tuned!',
        ),
        _FaqItem(
          question: 'How are calories calculated?',
          answer:
              'Calorie estimates are based on the type of exercise, duration, intensity, and your body stats (height, weight) from your profile.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Account & Profile',
      icon: Icons.person_outline,
      color: Color(0xFF00BFA5),
      faqs: [
        _FaqItem(
          question: 'How do I edit my profile?',
          answer:
              'Go to Profile → Edit Profile to update your name, email, phone, bio, gender, date of birth, height, and weight.',
        ),
        _FaqItem(
          question: 'Can I change my profile picture?',
          answer:
              'Yes. On the Edit Profile page, tap the camera icon on your avatar to take a photo, choose from gallery, or remove the current picture.',
        ),
        _FaqItem(
          question: 'How do I change my password?',
          answer:
              'Navigate to Profile → Settings → Account → Change Password. You\'ll be prompted to enter your current password and set a new one.',
        ),
      ],
    ),
    _FaqCategory(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      color: Color(0xFF2979FF),
      faqs: [
        _FaqItem(
          question: 'How do I manage notifications?',
          answer:
              'Go to Profile → Settings → Notifications to toggle Workout Reminders, Goal Alerts, Hydration Reminders, and Weekly Reports on or off.',
        ),
        _FaqItem(
          question: 'I\'m not receiving notifications',
          answer:
              'Make sure notifications are enabled both in the app settings and in your device\'s system settings for this app. Also check that Do Not Disturb mode is off.',
        ),
      ],
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    final results = <_FaqItem>[];
    for (final cat in _faqCategories) {
      for (final faq in cat.faqs) {
        if (faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query)) {
          results.add(faq);
        }
      }
    }
    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
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
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
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
                  const Icon(
                    Icons.support_agent,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Search our FAQ or reach out to us directly',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: InputDecoration(
                hintText: 'Search FAQ...',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? const Color(0xff2a2a3d)
                    : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (isSearching) ...[
              _sectionHeader(
                '${_filteredFaqs.length} result${_filteredFaqs.length == 1 ? '' : 's'} found',
              ),
              const SizedBox(height: 10),
              if (_filteredFaqs.isEmpty)
                _buildEmptySearch(isDark)
              else
                ..._filteredFaqs.map((faq) => _buildFaqTile(faq, isDark)),
            ] else ...[
              _sectionHeader('Frequently Asked Questions'),
              const SizedBox(height: 10),
              ..._faqCategories.map(
                (cat) => _buildCategorySection(cat, isDark),
              ),
            ],

            const SizedBox(height: 28),

            _sectionHeader('Still need help?'),
            const SizedBox(height: 12),

            _buildContactTile(
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: 'support@fitlife.app',
              color: const Color(0xFF7C4DFF),
              isDark: isDark,
              onTap: () => _showSnackBar('Opening email client...'),
            ),
            const SizedBox(height: 10),
            _buildContactTile(
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Available Mon–Fri, 9AM–6PM',
              color: const Color(0xFF00BFA5),
              isDark: isDark,
              onTap: () => _showSnackBar('Starting live chat...'),
            ),
            const SizedBox(height: 10),
            _buildContactTile(
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              subtitle: 'Help us improve the app',
              color: const Color(0xFFFF6D00),
              isDark: isDark,
              onTap: () => _showReportBugSheet(context),
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

  Widget _buildCategorySection(_FaqCategory category, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(category.icon, color: category.color, size: 22),
          ),
          title: Text(
            category.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          collapsedBackgroundColor: isDark
              ? const Color(0xff2a2a3d)
              : Colors.grey.shade100,
          backgroundColor: isDark
              ? const Color(0xff2a2a3d)
              : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          children: category.faqs
              .map((faq) => _buildFaqTile(faq, isDark, nested: true))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFaqTile(_FaqItem faq, bool isDark, {bool nested = false}) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        left: nested ? 10 : 0,
        right: nested ? 10 : 0,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff33334a) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: nested
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          title: Text(
            faq.question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          children: [
            Text(
              faq.answer,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearch(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try different keywords or browse categories below',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
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
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  void _showReportBugSheet(BuildContext context) {
    final bugController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Report a Bug',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Describe the issue you encountered',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: bugController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What went wrong?',
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xff2a2a3d)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showSnackBar('Bug report submitted. Thank you!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Report',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _FaqCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_FaqItem> faqs;

  const _FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.faqs,
  });
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
