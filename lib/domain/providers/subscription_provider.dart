import 'package:flutter_riverpod/legacy.dart';
import 'package:perfect_app/utils/logger.dart';
import '../../data/local/subscription_storage.dart';

final subscriptionStatusProvider =
    StateNotifierProvider<SubscriptionNotifier, bool>((ref) {
  final storage = ref.watch(subscriptionStorageProvider);
  return SubscriptionNotifier(storage);
});

class SubscriptionNotifier extends StateNotifier<bool> {
  final SubscriptionStorage _storage;

  SubscriptionNotifier(this._storage) : super(false) {
    loadSubscriptionStatus();
  }

  Future<void> loadSubscriptionStatus() async {
    final isSubscribed = await _storage.isSubscribed();
    state = isSubscribed;
  }

  Future<void> purchaseSubscription() async {
    Logger.log('💳 Purchasing subscription...'); // Добавляем отладку
    await _storage.setSubscribed(true);
    state = true;
    Logger.success('✅ Subscription purchased, state: $state'); // Добавляем отладку
  }
}
