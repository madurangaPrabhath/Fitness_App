import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitness_app/pages/signup.dart';
import 'package:fitness_app/pages/bottomnav.dart';
import 'package:fitness_app/pages/landing_page.dart';
import 'package:fitness_app/services/database.dart';
import 'package:fitness_app/services/shared_pref.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  final _auth = FirebaseAuth.instance;
  final _db = DatabaseMethods();
  final _prefs = SharedPreferenceMethods();
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final remember = await _prefs.getRememberMe();
    if (remember) {
      final saved = await _prefs.getSavedEmail();
      if (saved != null && saved.isNotEmpty) {
        setState(() {
          _rememberMe = true;
          _emailController.text = saved;
        });
      }
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final uid = credential.user!.uid;

      // Remember-me — non-critical, ignore failure
      try {
        await _prefs.setRememberMe(
          remember: _rememberMe,
          email: _emailController.text.trim(),
        );
      } catch (_) {}

      // Fetch Firestore profile + cache locally — non-critical, ignore failure
      try {
        final doc = await _db.getUser(uid);
        final data = doc.data() as Map<String, dynamic>? ?? {};
        await _prefs.saveUserSession(
          uid: uid,
          name: data['name'] ?? credential.user!.displayName ?? '',
          email: data['email'] ?? _emailController.text.trim(),
        );
      } catch (_) {
        // Still persist minimal session even if Firestore is unreachable
        try {
          await _prefs.saveUserSession(
            uid: uid,
            name: credential.user!.displayName ?? '',
            email: _emailController.text.trim(),
          );
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'user-not-found' => 'No account found for this email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        'invalid-credential' || 'INVALID_LOGIN_CREDENTIALS' =>
          'Incorrect email or password. Please try again.',
        'invalid-email' => 'The email address is invalid.',
        'user-disabled' => 'This account has been disabled.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        'network-request-failed' =>
          'No internet connection. Check your network.',
        _ => e.message ?? 'Sign in failed. Please try again.',
      };
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // Force the account picker on every tap
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null) {
        throw Exception('Google sign-in failed: could not obtain ID token.');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        try {
          final userInfo = {
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'createdAt': DateTime.now().toIso8601String(),
            'totalWorkouts': 0,
            'totalCalories': 0,
            'totalMinutes': 0,
          };
          await _db.addUser(user.uid, userInfo);
        } catch (_) {}
      }

      try {
        await _prefs.saveUserSession(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
      } catch (_) {}

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'account-exists-with-different-credential' =>
          'An account already exists with a different sign-in method.',
        'network-request-failed' =>
          'No internet connection. Check your network.',
        _ => e.message ?? 'Google sign-in failed. Please try again.',
      };
      if (mounted) _showError(msg);
    } on PlatformException catch (e) {
      final msg = switch (e.code) {
        'sign_in_cancelled' => 'Google sign-in was cancelled.',
        'network_error' => 'No internet connection. Check your network.',
        'sign_in_failed' =>
          'Google sign-in failed. Ensure SHA fingerprints are added in Firebase console.',
        _ => e.message ?? 'Google sign-in failed. Please try again.',
      };
      if (mounted) _showError(msg);
    } catch (e) {
      if (mounted) _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Image.asset(
                    'images/shoulder-stretch.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.45),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome\nBack!',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to keep pushing your limits',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.95),
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LandingPage()),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your email';
                        }
                        if (!RegExp(
                          r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      obscure: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.deepPurple.withValues(
                            alpha: 0.6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: _socialButton(
                            icon: Icons.g_mobiledata,
                            label: 'Google',
                            isDark: isDark,
                            onPressed: _isLoading ? null : _signInWithGoogle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _socialButton(
                            icon: Icons.apple,
                            label: 'Apple',
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _socialButton(
                            icon: Icons.facebook,
                            label: 'Facebook',
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xff2a2a3d) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required bool isDark,
    VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white70 : Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
