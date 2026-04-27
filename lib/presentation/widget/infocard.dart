import 'package:flutter/material.dart';


class InfoCard extends StatelessWidget {
  final Widget content;       // أيقونة أو نص أو صورة داخل الكارد
  final String label;         // اللايبل تحت الكارد
  final Color background;     // لون الخلفية
  final BorderRadius borderRadius; // الحواف
  final double width;
  final double height;
  final Color? labelColor;    // لون اللايبل
  final TextStyle labelStyle; // نمط الخط لللايبل

  const InfoCard({
    super.key,
    required this.content,
    required this.label,
    this.background = Colors.teal,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.width = 100,
    this.height = 100,
    this.labelColor,
    required this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: background,
            borderRadius: borderRadius,
          ),
          child: Center(child: content),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: labelStyle.copyWith(color: labelColor ?? labelStyle.color),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
