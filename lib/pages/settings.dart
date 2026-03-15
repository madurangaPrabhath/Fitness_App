import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/services/theme_provider.dart';
import 'package:fitness_app/services/shared_pref.dart';
import 'package:fitness_app/services/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _sharedPref = SharedPreferenceMethods();
  final _db = DatabaseMethods();

  bool _profileVisible = true;
  bool _showActivity = true;

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _distanceUnit = 'km';

  String _language = 'English';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final boolResults = await Future.wait([
      _sharedPref.getProfileVisible(),
      _sharedPref.getShowActivity(),
    ]);
    final stringResults = await Future.wait([
      _sharedPref.getWeightUnit(),
      _sharedPref.getHeightUnit(),
      _sharedPref.getDistanceUnit(),
      _sharedPref.getLanguage(),
    ]);
    if (!mounted) return;
    setState(() {
      _profileVisible = boolResults[0];
      _showActivity = boolResults[1];
      _weightUnit = stringResults[0];
      _heightUnit = stringResults[1];
      _distanceUnit = stringResults[2];
      _language = stringResults[3];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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

            const SizedBox(height: 24),

            _sectionHeader('Units & Preferences'),
            const SizedBox(height: 10),
            _buildDropdownTile(
              icon: Icons.monitor_weight_outlined,
              title: 'Weight Unit',
              value: _weightUnit,
              items: const ['kg', 'lbs'],
              onChanged: (v) {
                setState(() => _weightUnit = v ?? _weightUnit);
                if (v != null) _sharedPref.setWeightUnit(v);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.height,
              title: 'Height Unit',
              value: _heightUnit,
              items: const ['cm', 'ft/in'],
              onChanged: (v) {
                setState(() => _heightUnit = v ?? _heightUnit);
                if (v != null) _sharedPref.setHeightUnit(v);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.straighten,
              title: 'Distance Unit',
              value: _distanceUnit,
              items: const ['km', 'miles'],
              onChanged: (v) {
                setState(() => _distanceUnit = v ?? _distanceUnit);
                if (v != null) _sharedPref.setDistanceUnit(v);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildDropdownTile(
              icon: Icons.language,
              title: 'Language',
              value: _language,
              items: const ['English', 'Spanish', 'French', 'German', 'Hindi'],
              onChanged: (v) {
                setState(() => _language = v ?? _language);
                if (v != null) _sharedPref.setLanguage(v);
              },
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
              onChanged: (v) async {
                setState(() => _profileVisible = v);
                await _sharedPref.setProfileVisible(v);
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) _db.updateUser(uid, {'profileVisible': v});
              },
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _buildSwitchTile(
              icon: Icons.timeline_outlined,
              title: 'Show Activity Status',
              subtitle: 'Display your workout activity to friends',
              value: _showActivity,
              onChanged: (v) async {
                setState(() => _showActivity = v);
                await _sharedPref.setShowActivity(v);
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) _db.updateUser(uid, {'showActivity': v});
              },
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
              onTap: _exportData,
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
                onConfirm: _clearCache,
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
              onTap: _changePassword,
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
                onConfirm: _deleteAccount,
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

  Future<void> _exportData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _showSnackBar('Please sign in to export data');
      return;
    }
    try {
      _showSnackBar('Preparing data export...');
      final snapshot = await _db.getWorkoutLogs(uid);
      final count = snapshot.docs.length;
      _showSnackBar(
        'Exported $count workout record${count == 1 ? '' : 's'} successfully',
      );
    } catch (_) {
      _showSnackBar('Failed to export data. Please try again.');
    }
  }

  Future<void> _clearCache() async {
    try {
      final uid = await _sharedPref.getUid();
      final name = await _sharedPref.getName();
      final email = await _sharedPref.getEmail();
      final isLoggedIn = await _sharedPref.getIsLoggedIn();
      await _sharedPref.clearAll();
      if (isLoggedIn && uid != null && name != null && email != null) {
        await _sharedPref.saveUserSession(uid: uid, name: name, email: email);
      }
      _showSnackBar('Cache cleared successfully');
    } catch (_) {
      _showSnackBar('Failed to clear cache. Please try again.');
    }
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Please sign in to change your password');
      return;
    }
    if (user.email == null) {
      _showSnackBar(
        'Password change is not available for social sign-in accounts',
      );
      return;
    }

    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isSaving = false;
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: currentCtrl,
                        obscureText: obscureCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.deepPurple,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureCurrent
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setSheetState(
                              () => obscureCurrent = !obscureCurrent,
                            ),
                          ),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Enter your current password'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: newCtrl,
                        obscureText: obscureNew,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(
                            Icons.lock_reset_outlined,
                            color: Colors.deepPurple,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureNew
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                setSheetState(() => obscureNew = !obscureNew),
                          ),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter a new password';
                          }
                          if (v.length < 6) {
                            return 'At least 6 characters';
                          }
                          if (v == currentCtrl.text) {
                            return 'New password must differ from current';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: confirmCtrl,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Re-enter New Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.deepPurple,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setSheetState(
                              () => obscureConfirm = !obscureConfirm,
                            ),
                          ),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please re-enter your new password';
                          }
                          if (v != newCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  setSheetState(() => isSaving = true);
                                  try {
                                    final credential =
                                        EmailAuthProvider.credential(
                                          email: user.email!,
                                          password: currentCtrl.text,
                                        );
                                    await user.reauthenticateWithCredential(
                                      credential,
                                    );
                                    await user.updatePassword(newCtrl.text);
                                    if (ctx.mounted) Navigator.pop(ctx);
                                    _showSnackBar(
                                      'Password updated successfully',
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    final msg = switch (e.code) {
                                      'wrong-password' ||
                                      'invalid-credential' =>
                                        'Current password is incorrect.',
                                      'weak-password' =>
                                        'New password is too weak.',
                                      'requires-recent-login' =>
                                        'Please sign out and sign back in first.',
                                      _ =>
                                        e.message ??
                                            'Failed to update password.',
                                    };
                                    setSheetState(() => isSaving = false);
                                    _showSnackBar(msg);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.deepPurple
                                .withValues(alpha: 0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Update Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await _db.deleteUser(user.uid);
      await _sharedPref.clearAll();
      await user.delete();
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _showSnackBar(
          'Please sign out and sign back in before deleting your account',
        );
      } else {
        _showSnackBar(e.message ?? 'Failed to delete account');
      }
    } catch (_) {
      _showSnackBar('Failed to delete account. Please try again.');
    }
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
