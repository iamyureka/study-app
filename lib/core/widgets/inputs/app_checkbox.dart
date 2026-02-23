import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// A custom animated checkbox replacing the Material Checkbox.
class AppCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      widget.onChanged(!widget.value);
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    final checkColor = widget.checkColor ?? theme.colorScheme.onPrimary;
    final inactiveColor = theme.colorScheme.outline;

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.value ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: widget.value ? activeColor : inactiveColor,
              width: 2,
            ),
          ),
          child: widget.value
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: checkColor,
                )
              : null,
        ),
      ),
    );
  }
}
