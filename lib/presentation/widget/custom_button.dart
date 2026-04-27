import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  final Color? iconColor;

  const CustomButton._({
    this.text,
    this.icon,
    this.onPressed,
    this.color,
    this.textStyle,
    this.iconColor,
    super.key,
  });

  /// زر نص فقط
  factory CustomButton.text({
  required String text,
  VoidCallback? onPressed,
  Color? color,
  required TextStyle textStyle,
}) =>
    CustomButton._(
      text: text,
      onPressed: onPressed,
      color: color,
      textStyle: textStyle,
    );

  /// زر نص مع أيقونة
  factory CustomButton.textWithIcon({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    TextStyle? textStyle,
    Color? iconColor,
  }) {
    return CustomButton._(
      text: text,
      icon: icon,
      onPressed: onPressed,
      color: color,
      textStyle: textStyle,
      iconColor: iconColor,
    );
  }

  /// زر أيقونة فقط
  factory CustomButton.icon({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return CustomButton._(
      icon: icon,
      onPressed: onPressed,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;

    if (text != null && icon == null) {
      // زر نص فقط
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: onPressed,
        child: Text(text!, style: textStyle),
      );
    } else if (text != null && icon != null) {
      // زر نص مع أيقونة
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
        label: Text(text!, style: textStyle),
      );
    }
      // زر أيقونة فقط
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: buttonColor,
        iconSize: 28,
      );
    }
  }

