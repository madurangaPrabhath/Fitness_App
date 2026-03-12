import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceMethods {
  static const String _keyUid = 'uid';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyRememberMe = 'rememberMe';
  static const String _keySavedEmail = 'savedEmail';

  static const String _keyPhone = 'phone';
  static const String _keyBio = 'bio';
  static const String _keyGender = 'gender';
  static const String _keyDob = 'dob';
  static const String _keyHeightCm = 'heightCm';
  static const String _keyWeightKg = 'weightKg';

  static const String _keyDarkMode = 'darkMode';

  static const String _keyWorkoutReminders = 'workoutReminders';
  static const String _keyGoalAlerts = 'goalAlerts';
  static const String _keyHydrationReminders = 'hydrationReminders';
  static const String _keyWeeklyReport = 'weeklyReport';

  static const String _keyProfileVisible = 'profileVisible';
  static const String _keyShowActivity = 'showActivity';

  static const String _keyPhotoPath = 'photoPath';
  static const String _keyPhotoData = 'photoData';

  static const String _keyWeightUnit = 'weightUnit';
  static const String _keyHeightUnit = 'heightUnit';
  static const String _keyDistanceUnit = 'distanceUnit';
  static const String _keyLanguage = 'language';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveUserSession({
    required String uid,
    required String name,
    required String email,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<void> clearUserSession() async {
    final prefs = await _prefs;
    await prefs.remove(_keyUid);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<bool> getIsLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<String?> getUid() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUid);
  }

  Future<String?> getName() async {
    final prefs = await _prefs;
    return prefs.getString(_keyName);
  }

  Future<void> setName(String name) async {
    final prefs = await _prefs;
    await prefs.setString(_keyName, name);
  }

  Future<String?> getEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_keyEmail);
  }

  Future<void> setRememberMe({
    required bool remember,
    required String email,
  }) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyRememberMe, remember);
    await prefs.setString(_keySavedEmail, remember ? email : '');
  }

  Future<bool> getRememberMe() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  Future<String?> getSavedEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_keySavedEmail);
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required String gender,
    required String dob,
    required double heightCm,
    required double weightKg,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyGender, gender);
    await prefs.setString(_keyDob, dob);
    await prefs.setDouble(_keyHeightCm, heightCm);
    await prefs.setDouble(_keyWeightKg, weightKg);
  }

  Future<String?> getPhone() async => (await _prefs).getString(_keyPhone);

  Future<void> setPhone(String phone) async =>
      (await _prefs).setString(_keyPhone, phone);

  Future<String?> getBio() async => (await _prefs).getString(_keyBio);

  Future<void> setBio(String bio) async =>
      (await _prefs).setString(_keyBio, bio);

  Future<String?> getGender() async => (await _prefs).getString(_keyGender);

  Future<void> setGender(String gender) async =>
      (await _prefs).setString(_keyGender, gender);

  Future<String?> getDob() async => (await _prefs).getString(_keyDob);

  Future<void> setDob(String dob) async =>
      (await _prefs).setString(_keyDob, dob);

  Future<double> getHeightCm() async =>
      (await _prefs).getDouble(_keyHeightCm) ?? 170.0;

  Future<void> setHeightCm(double value) async =>
      (await _prefs).setDouble(_keyHeightCm, value);

  Future<double> getWeightKg() async =>
      (await _prefs).getDouble(_keyWeightKg) ?? 70.0;

  Future<void> setWeightKg(double value) async =>
      (await _prefs).setDouble(_keyWeightKg, value);

  Future<bool> getDarkMode() async =>
      (await _prefs).getBool(_keyDarkMode) ?? false;

  Future<void> setDarkMode(bool value) async =>
      (await _prefs).setBool(_keyDarkMode, value);

  Future<bool> getWorkoutReminders() async =>
      (await _prefs).getBool(_keyWorkoutReminders) ?? true;

  Future<void> setWorkoutReminders(bool value) async =>
      (await _prefs).setBool(_keyWorkoutReminders, value);

  Future<bool> getGoalAlerts() async =>
      (await _prefs).getBool(_keyGoalAlerts) ?? true;

  Future<void> setGoalAlerts(bool value) async =>
      (await _prefs).setBool(_keyGoalAlerts, value);

  Future<bool> getHydrationReminders() async =>
      (await _prefs).getBool(_keyHydrationReminders) ?? false;

  Future<void> setHydrationReminders(bool value) async =>
      (await _prefs).setBool(_keyHydrationReminders, value);

  Future<bool> getWeeklyReport() async =>
      (await _prefs).getBool(_keyWeeklyReport) ?? true;

  Future<void> setWeeklyReport(bool value) async =>
      (await _prefs).setBool(_keyWeeklyReport, value);

  Future<bool> getProfileVisible() async =>
      (await _prefs).getBool(_keyProfileVisible) ?? true;

  Future<void> setProfileVisible(bool value) async =>
      (await _prefs).setBool(_keyProfileVisible, value);

  Future<bool> getShowActivity() async =>
      (await _prefs).getBool(_keyShowActivity) ?? true;

  Future<void> setShowActivity(bool value) async =>
      (await _prefs).setBool(_keyShowActivity, value);

  Future<String> getWeightUnit() async =>
      (await _prefs).getString(_keyWeightUnit) ?? 'kg';

  Future<void> setWeightUnit(String unit) async =>
      (await _prefs).setString(_keyWeightUnit, unit);

  Future<String> getHeightUnit() async =>
      (await _prefs).getString(_keyHeightUnit) ?? 'cm';

  Future<void> setHeightUnit(String unit) async =>
      (await _prefs).setString(_keyHeightUnit, unit);

  Future<String> getDistanceUnit() async =>
      (await _prefs).getString(_keyDistanceUnit) ?? 'km';

  Future<void> setDistanceUnit(String unit) async =>
      (await _prefs).setString(_keyDistanceUnit, unit);

  Future<String> getLanguage() async =>
      (await _prefs).getString(_keyLanguage) ?? 'English';

  Future<void> setLanguage(String language) async =>
      (await _prefs).setString(_keyLanguage, language);

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<String?> getPhotoPath() async =>
      (await _prefs).getString(_keyPhotoPath);

  Future<void> setPhotoPath(String? path) async {
    final prefs = await _prefs;
    if (path == null || path.isEmpty) {
      await prefs.remove(_keyPhotoPath);
    } else {
      await prefs.setString(_keyPhotoPath, path);
    }
  }

  Future<String?> getPhotoData() async =>
      (await _prefs).getString(_keyPhotoData);

  Future<void> setPhotoData(String? data) async {
    final prefs = await _prefs;
    if (data == null || data.isEmpty) {
      await prefs.remove(_keyPhotoData);
    } else {
      await prefs.setString(_keyPhotoData, data);
    }
  }
}
