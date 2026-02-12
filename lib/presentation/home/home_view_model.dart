import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/local/subscription_storage.dart';

// Используем AutoDispose для автоматической очистки
final homeViewModelProvider = Provider.autoDispose<HomeViewModel>((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel {
  final Ref _ref;
  
  HomeViewModel(this._ref);
  
  Future<void> logout(BuildContext context) async {
    final storage = _ref.read(subscriptionStorageProvider);
    await storage.clearSubscription();
    
    if (context.mounted) {
      context.go('/onboarding');
    }
  }
}