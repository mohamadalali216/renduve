import 'package:flutter/material.dart';

class FlexibleBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Widget leftWidget;
  final Widget centerWidget;
  final Widget rightWidget;
  final double height;

  const FlexibleBar({
    super.key,
    required this.backgroundColor,
    required this.borderRadius,
    required this.leftWidget,
    required this.centerWidget,
    required this.rightWidget,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget,
          centerWidget,
          rightWidget,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
