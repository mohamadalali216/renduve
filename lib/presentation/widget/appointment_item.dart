import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';

class AppointmentItemWidget extends StatelessWidget {
  final String time;
  final String name;
  final String id;
  final String lastDate;
  final AppointmentStatus status;

  const AppointmentItemWidget({
    super.key,
    required this.time,
    required this.name,
    required this.id,
    required this.lastDate,
    required this.status,
  });

  Color getStatusColor() {
    switch (status) {
      case AppointmentStatus.done:
        return Colors.green;
      case AppointmentStatus.canceled:
        return Colors.red;
      case AppointmentStatus.missed:
        return Colors.orange;
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(   // ← هذا يجعل كل الكونتينرات بنفس الارتفاع
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.gray,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ← مهم جدًا
          children: [
            /// TIME CONTAINER (أسود)
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                time,
                style: AppTextStyles.bold_12.copyWith(color: AppColors.white),
              ),
            ),

            const SizedBox(width: 12),

            /// DETAILS CONTAINER (أبيض)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bold_16.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID Number: $id",
                      style: AppTextStyles.bold_10.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Last Randevu: $lastDate",
                      style: AppTextStyles.bold_10.copyWith(color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// STATUS CONTAINER (لون الحالة)
            Container(
              width: 16,
              decoration: BoxDecoration(
                color: getStatusColor(),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AppointmentStatus {
  done,
  canceled,
  missed,
}
