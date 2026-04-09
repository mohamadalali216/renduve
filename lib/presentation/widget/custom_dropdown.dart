import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  final double height;
  final double? width;            // ← الجديد
  final double borderRadius;

  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 50,
    this.width,                   // ← الجديد
    this.borderRadius = 12,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,               // ← استخدامه
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.grey.shade400,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.arrow_drop_down, color: iconColor ?? Colors.teal),
          style: TextStyle(
            color: textColor ?? Colors.teal,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
