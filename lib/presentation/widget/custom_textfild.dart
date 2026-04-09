import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint; // النص اللي يظهر كمثال
  final bool obscureText;
  final IconData? icon;
  final TextInputType keyboardType;
  final Color? color;
  final bool isPassword;
  final Color? backgroundColor;
  final Color? textColor;
  final InputBorder? border;
  final TextStyle? hintStyle;
  final Color? iconColor;
  const CustomTextField._({
    required this.label,
    this.hint,
    this.obscureText = false,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.color,
    this.isPassword = false,
    this.backgroundColor,
    this.textColor,
    this.border,
    this.hintStyle,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  /// حقل نص عادي
  factory CustomTextField.normal({
    String? label,
    String? hint,
 
    TextInputType keyboardType = TextInputType.text,
    Color? color,
    Color? backgroundColor,
    Color? textColor,
    InputBorder? border,
    TextStyle? hintStyle,
  }) {
    return CustomTextField._(
      label: label ?? '',
      hint: hint,

      keyboardType: keyboardType,
      color: color,
      backgroundColor: backgroundColor,
      textColor: textColor,
      border: border,
      hintStyle: hintStyle,
    );
  }

  /// حقل نص مع أيقونة
  factory CustomTextField.withIcon({
    String? label,
    String? hint,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    Color? color,
    Color? backgroundColor,
    Color? textColor,
    InputBorder? border,
    TextStyle? hintStyle,
  }) {
    return CustomTextField._(
      label: label ?? '',
      hint: hint,
      icon: icon,
      keyboardType: keyboardType,
      color: color,
      backgroundColor: backgroundColor,
      textColor: textColor,
      border: border,
      hintStyle: hintStyle,
    );
  }

  /// حقل كلمة مرور مع إظهار/إخفاء
  factory CustomTextField.password({
    required String label,
    String? hint,
    required TextEditingController controller,
    Color? color,
    Color? backgroundColor,
  }) {
    return CustomTextField._(
      label: label,
      hint: hint,
      obscureText: true,
      icon: Icons.lock,
      color: color,
      isPassword: true,
      backgroundColor: backgroundColor,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final fieldColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: TextStyle(
              color: fieldColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (widget.label.isNotEmpty) const SizedBox(height: 8),
        TextField(

          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          style: widget.textColor != null ? TextStyle(color: widget.textColor) : null,
          decoration: InputDecoration(
            hintText: widget.hint, // النص اللي يظهر كمثال
            hintStyle: widget.hintStyle,
            prefixIcon: widget.icon != null ? Icon(widget.icon, color: fieldColor) : null,
            border: widget.border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: fieldColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
