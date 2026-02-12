import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perfect_app/utils/logger.dart';
import 'widgets/subscription_card.dart';
import 'widgets/payment_bottom_sheet.dart';
import 'widgets/payment_overlay.dart';
import '../../domain/models/subscription_plan.dart';
import '../../domain/providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  SubscriptionPlan? _selectedPlan;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenContext = context;
    });
  }

  @override
  void dispose() {
    PaymentOverlay.hide();
    super.dispose();
  }

  late BuildContext _screenContext;

  Future<void> _simulatePurchase() async {
    if (_isProcessing) return;
    _isProcessing = true;

    print('🔄 Starting purchase simulation...');

    // Шаг 1: Инициализация платежа
    PaymentOverlay.show(
      context: _screenContext,
      emoji: '💳',
      message: 'Инициализация платежа...',
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!_screenContext.mounted) {
      _isProcessing = false;
      return;
    }

    // Шаг 2: Проверка карты
    PaymentOverlay.update(
      emoji: '🔒',
      message: 'Проверка платежных данных...',
    );

    await Future.delayed(const Duration(seconds: 1));
    if (!_screenContext.mounted) {
      _isProcessing = false;
      return;
    }

    // Шаг 3: Обработка платежа
    PaymentOverlay.update(
      emoji: '⚡',
      message: 'Обработка платежа...',
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!_screenContext.mounted) {
      _isProcessing = false;
      return;
    }

    // Шаг 4: Успех!
    PaymentOverlay.update(
      emoji: '✅',
      message: 'Платеж успешно обработан!',
      backgroundColor: Colors.green,
    );

    await Future.delayed(const Duration(seconds: 1));
    PaymentOverlay.hide();

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
    } finally {
      _isProcessing = false;
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
          Navigator.pop(context);
          _simulatePurchase();
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
                      if (!_isProcessing) {
                        // Проверка внутри
                        Logger.log(
                            'Tapped: ${plan.title}, isPopular: ${plan.isPopular}');
                        setState(() {
                          _selectedPlan = plan;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (_selectedPlan != null && !_isProcessing)
                  ? () => _showPaymentSheet(_selectedPlan!)
                  : null, // Здесь null допустим для ElevatedButton
              child: Text(_isProcessing ? 'Обработка...' : 'Продолжить'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
