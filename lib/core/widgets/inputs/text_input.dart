import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_sizes.dart';

/// Custom text input widget with validation and modern styling
class TextInput extends StatefulWidget {
  const TextInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.fillColor,
    this.borderColor,
    this.validator,
    this.size = InputSize.medium,
    this.showBorder = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;
  final Color? fillColor;
  final Color? borderColor;
  final String? Function(String?)? validator;
  final InputSize size;
  final bool showBorder;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  double get _inputHeight {
    switch (widget.size) {
      case InputSize.small:
        return AppSizes.inputHeightSm;
      case InputSize.medium:
        return AppSizes.inputHeight;
    }
  }

  double get _contentPadding {
    switch (widget.size) {
      case InputSize.small:
        return AppSizes.sm;
      case InputSize.medium:
        return AppSizes.md;
    }
  }

  double get _fontSize => widget.size == InputSize.small ? 14 : 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveFillColor = widget.fillColor ?? colorScheme.surface;
    final defaultBorderColor = widget.borderColor ?? colorScheme.outline;

    // Determine the border color based on focus and error state
    Color currentBorderColor;
    if (widget.errorText != null) {
      currentBorderColor = colorScheme.error;
    } else if (_isFocused) {
      currentBorderColor = colorScheme.primary;
    } else {
      currentBorderColor = defaultBorderColor;
    }

    // Determine border width
    final borderWidth = _isFocused || widget.errorText != null ? 2.0 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: textTheme.titleSmall?.copyWith(
              color: widget.enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
        ],

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.enabled ? effectiveFillColor : colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: widget.showBorder
                ? Border.all(
                    color: widget.enabled ? currentBorderColor : colorScheme.onSurface.withOpacity(0.12),
                    width: borderWidth,
                  )
                : null,
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(left: _contentPadding),
                  child: Icon(
                    widget.prefixIcon,
                    size: _fontSize + 4,
                    color: widget.enabled
                        ? (_isFocused ? colorScheme.primary : colorScheme.onSurfaceVariant)
                        : colorScheme.onSurface.withOpacity(0.38),
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _contentPadding,
                    vertical: widget.maxLines > 1 ? _contentPadding : 0,
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    initialValue: widget.initialValue,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    obscureText: widget.obscureText,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    maxLines: widget.obscureText ? 1 : widget.maxLines,
                    minLines: widget.minLines,
                    maxLength: widget.maxLength,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    inputFormatters: widget.inputFormatters,
                    onChanged: widget.onChanged,
                    onFieldSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                    validator: widget.validator,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: _fontSize,
                      color: widget.enabled
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withOpacity(0.5),
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: widget.maxLines == 1 ? _contentPadding : 0,
                      ),
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      counterText: '', // Remove built-in counter if present
                    ),
                  ),
                ),
              ),

              if (widget.suffixIcon != null)
                Padding(
                  padding: EdgeInsets.only(right: _contentPadding / 2),
                  child: IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      size: _fontSize + 4,
                      color: widget.enabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface.withOpacity(0.38),
                    ),
                    onPressed: widget.onSuffixIconPressed,
                  ),
                ),
            ],
          ),
        ),

        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: AppSizes.xs),
          Text(
            widget.errorText ?? widget.helperText!,
            style: textTheme.bodySmall?.copyWith(
              color: widget.errorText != null
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

enum InputSize { small, medium }
