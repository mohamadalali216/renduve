import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final double radius;

  const UserProfile({
    Key? key,
    required this.name,
    this.radius = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.gray_light_2,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.gray_light_2,
          ),
        ),
      ],
    );
  }
}
