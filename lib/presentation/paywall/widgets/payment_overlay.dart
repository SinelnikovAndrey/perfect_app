import 'package:flutter/material.dart';

class PaymentOverlay {
  static OverlayEntry? _currentEntry;

  static void show({
    required BuildContext context,
    required String emoji,
    required String message,
    Color? backgroundColor,
  }) {
    hide(); // Скрываем предыдущий, если есть

    _currentEntry = OverlayEntry(
      builder: (context) => _PaymentOverlayContent(
        emoji: emoji,
        message: message,
        backgroundColor: backgroundColor,
      ),
    );

    Overlay.of(context).insert(_currentEntry!);
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }

  static void update({
    required String emoji,
    required String message,
    Color? backgroundColor,
  }) {
    if (_currentEntry != null) {
      final overlay = _currentEntry!;
      overlay.markNeedsBuild();
    }
  }
}

class _PaymentOverlayContent extends StatefulWidget {
  final String emoji;
  final String message;
  final Color? backgroundColor;

  const _PaymentOverlayContent({
    required this.emoji,
    required this.message,
    this.backgroundColor,
  });

  @override
  State<_PaymentOverlayContent> createState() => _PaymentOverlayContentState();
}

class _PaymentOverlayContentState extends State<_PaymentOverlayContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(_PaymentOverlayContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emoji != widget.emoji ||
        oldWidget.message != widget.message) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: (widget.backgroundColor ?? Colors.black).withOpacity(0.8),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Анимированная эмодзи
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0.8, end: 1.0),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: 1.0 + (0.2 * scale),
                          child: child,
                        );
                      },
                      child: Text(
                        widget.emoji,
                        style: const TextStyle(
                          fontSize: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Текст операции
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Индикатор загрузки
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
