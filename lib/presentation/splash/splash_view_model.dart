import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/providers/subscription_provider.dart';

final splashViewModelProvider = Provider.autoDispose<SplashViewModel>((ref) {
  return SplashViewModel(ref);
});

class SplashViewModel {
  final Ref _ref;

  SplashViewModel(this._ref);

  Future<void> checkSubscription(BuildContext context) async {
    final subscriptionNotifier = _ref.read(subscriptionStatusProvider.notifier);
    await subscriptionNotifier.loadSubscriptionStatus();

    final isSubscribed = _ref.read(subscriptionStatusProvider);

    if (isSubscribed) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }
}
