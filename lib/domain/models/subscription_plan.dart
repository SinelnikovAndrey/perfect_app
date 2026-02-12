enum SubscriptionPeriod { monthly, yearly }

class SubscriptionPlan {
  final String id; // Добавляем уникальный ID
  final SubscriptionPeriod period;
  final String title;
  final String price;
  final String? discount;
  final bool isPopular;

  SubscriptionPlan({
    required this.id, // Обязательный параметр
    required this.period,
    required this.title,
    required this.price,
    this.discount,
    this.isPopular = false,
  });

  static List<SubscriptionPlan> getPlans() {
    return [
      SubscriptionPlan(
        id: 'monthly_1', // Уникальный ID
        period: SubscriptionPeriod.monthly,
        title: 'Месячная подписка',
        price: '499 ₽/мес',
        discount: null,
        isPopular: true,
      ),
      SubscriptionPlan(
        id: 'yearly_1', // Уникальный ID
        period: SubscriptionPeriod.yearly,
        title: 'Годовая подписка',
        price: '2 990 ₽/год',
        discount: 'Скидка 50%',
        isPopular: false,
      ),
    ];
  }
}
