import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_app/utils/logger.dart';
import 'widgets/subscription_card.dart';
import 'widgets/payment_bottom_sheet.dart';
import '../../domain/models/subscription_plan.dart';
import '../../domain/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  SubscriptionPlan? _selectedPlan;

  // Сохраняем контекст экрана
  late BuildContext _screenContext;

  @override
  void initState() {
    super.initState();
    _screenContext = context;
  }

  Future<void> _simulatePurchase() async {
    print('🔄 Starting purchase simulation...');

    // Используем сохраненный контекст экрана
    ScaffoldMessenger.of(_screenContext).showSnackBar(
      const SnackBar(
        content: Text('Обработка платежа...'),
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));
    print('⏰ 2 seconds passed');

    if (!_screenContext.mounted) {
      print('❌ Screen context not mounted');
      return;
    }

    try {
      print('💳 Calling purchaseSubscription...');
      final subscriptionNotifier =
          ref.read(subscriptionStatusProvider.notifier);
      await subscriptionNotifier.purchaseSubscription();
      print('✅ Purchase completed');

      if (_screenContext.mounted) {
        print('🚀 Navigating to home...');
        _screenContext.go('/home');
      }
    } catch (e) {
      print('❌ Error: $e');
      if (_screenContext.mounted) {
        ScaffoldMessenger.of(_screenContext).showSnackBar(
          const SnackBar(
            content: Text('Ошибка при покупке'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showPaymentSheet(SubscriptionPlan plan) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentBottomSheet(
        plan: plan,
        onPaymentSuccess: () {
          context.push('/home'); // Закрываем BottomSheet
          _simulatePurchase(); // Вызываем без передачи контекста
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = SubscriptionPlan.getPlans();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Премиум доступ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Выберите план подписки',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Получите доступ ко всем функциям приложения',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return SubscriptionCard(
                    plan: plan,
                    isSelected: _selectedPlan?.id == plan.id,
                    onTap: () {
                      Logger.log(
                          'Tapped: ${plan.title}, isPopular: ${plan.isPopular}');
                      setState(() {
                        _selectedPlan = plan;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedPlan != null
                  ? () => _showPaymentSheet(_selectedPlan!)
                  : null,
              child: const Text('Продолжить'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
