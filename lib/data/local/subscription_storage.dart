import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_app/data/local/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SubscriptionStorage {
  final SharedPreferences _prefs;
  
  SubscriptionStorage(this._prefs);
  
  Future<bool> isSubscribed() async {
    return _prefs.getBool(AppConstants.subscriptionKey) ?? false;
  }
  
  Future<void> setSubscribed(bool value) async {
    await _prefs.setBool(AppConstants.subscriptionKey, value);
  }
  
  Future<void> clearSubscription() async {
    await _prefs.remove(AppConstants.subscriptionKey);
  }
}

final subscriptionStorageProvider = Provider<SubscriptionStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SubscriptionStorage(prefs);
});