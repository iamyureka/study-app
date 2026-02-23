import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// A custom modern card component that replaces Material Card.
/// Provides smooth scaling on tap and custom shadow parameters.
class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool animated;
  final Clip? clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.animated = true,
    this.clipBehavior,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.animated) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.animated) {
      _controller.reverse();
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (widget.onTap != null && widget.animated) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = widget.color ?? theme.colorScheme.surface;

    Widget cardContent = Container(
      padding: widget.padding ?? const EdgeInsets.all(AppSizes.md),
      margin: widget.margin,
      clipBehavior: widget.clipBehavior ?? Clip.none,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSizes.cardRadius),
        border: widget.border ?? Border.all(color: theme.colorScheme.outlineVariant, width: 1),
        boxShadow: widget.boxShadow ?? [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      cardContent = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
