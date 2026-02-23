import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// Primary button widget with loading state and modern styling
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.size = ButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final ButtonSize size;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _buttonHeight {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSizes.buttonHeightSm;
      case ButtonSize.medium:
        return AppSizes.buttonHeight;
      case ButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveOnPressed = widget.isEnabled && !widget.isLoading
        ? widget.onPressed
        : null;

    final backgroundColor = widget.backgroundColor ??
        (widget.isOutlined ? Colors.transparent : colorScheme.primary);

    final foregroundColor = widget.textColor ??
        (widget.isOutlined ? colorScheme.primary : colorScheme.onPrimary);

    final disabledBackgroundColor = colorScheme.onSurface.withOpacity(0.12);
    final disabledForegroundColor = colorScheme.onSurface.withOpacity(0.38);

    final currentBackgroundColor = widget.isEnabled ? backgroundColor : disabledBackgroundColor;
    final currentForegroundColor = widget.isEnabled ? foregroundColor : disabledForegroundColor;
    final currentBorderColor = widget.isEnabled
        ? (widget.backgroundColor ?? colorScheme.primary)
        : colorScheme.onSurface.withOpacity(0.12);

    return GestureDetector(
      onTapDown: (_) {
        if (effectiveOnPressed != null) {
          setState(() => _isPressed = true);
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (effectiveOnPressed != null) {
          setState(() => _isPressed = false);
          _animationController.reverse();
          effectiveOnPressed();
        }
      },
      onTapCancel: () {
        if (effectiveOnPressed != null) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width ?? double.infinity,
          height: widget.height ?? _buttonHeight,
          decoration: BoxDecoration(
            color: widget.isOutlined ? Colors.transparent : currentBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: widget.isOutlined
                ? Border.all(color: currentBorderColor, width: 1.5)
                : null,
            boxShadow: (!widget.isOutlined && widget.isEnabled && !_isPressed)
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: _buildButtonContent(currentForegroundColor),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent(Color foregroundColor) {
    if (widget.isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    final textWidget = Text(
      widget.text,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        color: foregroundColor,
        letterSpacing: 0.2,
      ),
    );

    if (widget.icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(
      widget.icon,
      size: _iconSize,
      color: foregroundColor,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widget.iconPosition == IconPosition.left
          ? [
              iconWidget,
              const SizedBox(width: AppSizes.sm),
              textWidget,
            ]
          : [
              textWidget,
              const SizedBox(width: AppSizes.sm),
              iconWidget,
            ],
    );
  }
}

enum IconPosition { left, right }

enum ButtonSize { small, medium, large }
