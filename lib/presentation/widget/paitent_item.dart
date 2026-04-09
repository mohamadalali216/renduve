import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';

class PatientItemWidget extends StatelessWidget {
  final String number;
  final String name;
  final String id;
  final String date;
  final VoidCallback? onTap;

  const PatientItemWidget({
    super.key,
    required this.number,
    required this.name,
    required this.id,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 1) الرقم داخل كونتينر أسود
        Container(
          width: 55,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: AppTextStyles.bold_16.copyWith(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// 2) النصوص داخل كونتينر أبيض
        Expanded(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bold_16.copyWith(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "ID Number $id",
                  style: AppTextStyles.bold_10.copyWith(
                    color: AppColors.black,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "Last Randevu $date",
                  style: AppTextStyles.bold_10.copyWith(
                    color: AppColors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// 3) السهم داخل كونتينر أخضر
        InkWell(
          onTap: onTap,
          child: Container(
            width: 55,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
