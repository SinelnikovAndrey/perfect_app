import 'package:flutter/material.dart';
import '../../../domain/models/subscription_plan.dart';

class PaymentBottomSheet extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onPaymentSuccess;

  const PaymentBottomSheet({
    super.key,
    required this.plan,
    required this.onPaymentSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Выберите способ оплаты',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Тариф: ${plan.title}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildPaymentOption(
            context,
            icon: Icons.apple,
            title: 'Apple Pay',
            subtitle: 'Быстрая и безопасная оплата',
            onTap: onPaymentSuccess,
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            context,
            icon: Icons.credit_card,
            title: 'Банковская карта',
            subtitle: 'Visa, Mastercard, Мир',
            onTap: onPaymentSuccess,
          ),
          const SizedBox(height: 24),
          Text(
            'Оплата: ${plan.price}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
