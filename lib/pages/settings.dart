import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/services/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _workoutReminders = true;
  bool _goalAlerts = true;
  bool _hydrationReminders = false;
  bool _weeklyReport = true;

  bool _profileVisible = true;
  bool _showActivity = true;

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _distanceUnit = 'km';

  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _sectionHeader('Appearance'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Switch between light and dark theme',
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _sectionHeader('Notifications'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.fitness_center,
              title: 'Workout Reminders',
              subtitle: 'Get reminded before scheduled workouts',
              value: _workoutReminders,
              onChanged: (v) => setState(() => _workoutReminders = v),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.emoji_events_outlined,
              title: 'Goal Alerts',
              subtitle: 'Notifications when you hit your targets',
              value: _goalAlerts,
              onChanged: (v) => setState(() => _goalAlerts = v),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.water_drop_outlined,
              title: 'Hydration Reminders',
              subtitle: 'Periodic reminders to drink water',
              value: _hydrationReminders,
              onChanged: (v) => setState(() => _hydrationReminders = v),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.bar_chart_outlined,
              title: 'Weekly Report',
              subtitle: 'Receive a summary of your weekly progress',
              value: _weeklyReport,
              onChanged: (v) => setState(() => _weeklyReport = v),
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _sectionHeader('Units & Preferences'),
            const SizedBox(height: 10),
            _buildDropdownTile(
              icon: Icons.monitor_weight_outlined,
              title: 'Weight Unit',
              value: _weightUnit,
              items: const ['kg', 'lbs'],
              onChanged: (v) => setState(() => _weightUnit = v ?? _weightUnit),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.height,
              title: 'Height Unit',
              value: _heightUnit,
              items: const ['cm', 'ft/in'],
              onChanged: (v) => setState(() => _heightUnit = v ?? _heightUnit),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.straighten,
              title: 'Distance Unit',
              value: _distanceUnit,
              items: const ['km', 'miles'],
              onChanged: (v) =>
                  setState(() => _distanceUnit = v ?? _distanceUnit),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.language,
              title: 'Language',
              value: _language,
              items: const ['English', 'Spanish', 'French', 'German', 'Hindi'],
              onChanged: (v) => setState(() => _language = v ?? _language),
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _sectionHeader('Privacy'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.visibility_outlined,
              title: 'Profile Visibility',
              subtitle: 'Allow others to see your profile',
              value: _profileVisible,
              onChanged: (v) => setState(() => _profileVisible = v),
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.timeline_outlined,
              title: 'Show Activity Status',
              subtitle: 'Display your workout activity to friends',
              value: _showActivity,
              onChanged: (v) => setState(() => _showActivity = v),
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            _sectionHeader('Data & Storage'),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: Icons.download_outlined,
              title: 'Export Data',
              subtitle: 'Download your workout history',
              isDark: isDark,
              onTap: () => _showSnackBar('Preparing data export...'),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.cached,
              title: 'Clear Cache',
              subtitle: 'Free up storage space',
              isDark: isDark,
              onTap: () => _showConfirmDialog(
                title: 'Clear Cache',
                message:
                    'This will remove temporary files. Your data will not be affected.',
                onConfirm: () => _showSnackBar('Cache cleared successfully'),
              ),
            ),

            const SizedBox(height: 24),

            _sectionHeader('Account'),
            const SizedBox(height: 10),
            _buildActionTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              isDark: isDark,
              onTap: () => _showSnackBar('Change password flow coming soon'),
            ),
            const SizedBox(height: 8),
            _buildActionTile(
              icon: Icons.delete_forever_outlined,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account and data',
              isDark: isDark,
              color: Colors.redAccent,
              onTap: () => _showConfirmDialog(
                title: 'Delete Account',
                message:
                    'This action is permanent and cannot be undone. All your data will be deleted.',
                isDestructive: true,
                onConfirm: () => _showSnackBar('Account deletion requested'),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Column(
                children: [
                  Text(
                    'FitLife v1.0.0',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with ♥ for your fitness',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    Color color = Colors.deepPurple,
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
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color == Colors.redAccent ? color : null,
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

  void _showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.redAccent : null,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              'Confirm',
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
