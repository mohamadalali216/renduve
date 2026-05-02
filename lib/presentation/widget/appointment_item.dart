import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';

class AppointmentItemWidget extends StatelessWidget {
  final String time;
  final String name;
  final String id;
  final String lastDate;
  final AppointmentStatus status;
  final Color statusColor;
  final int appointmentId;
  final VoidCallback onDelete;

  const AppointmentItemWidget({
    super.key,
    required this.time,
    required this.name,
    required this.id,
    required this.lastDate,
    required this.status,
    required this.statusColor,
    required this.appointmentId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onLongPress: () => _showDeleteDialog(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: statusColor == AppColors.error 
                ? statusColor.withOpacity(0.15) 
                : AppColors.gray,
            border: Border.all(
              color: statusColor == AppColors.error 
                  ? AppColors.error 
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

              /// STATUS CONTAINER (اللون المتغير) 🎨 - wider for better visibility
              Container(
                width: 24,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// دالة عرض رسالة الحذف
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            'حذف الموعد',
            style: AppTextStyles.bold_16.copyWith(color: AppColors.black),
          ),
          content: Text(
            'هل تريد حذف هذا الموعد؟',
            style: AppTextStyles.bold_12.copyWith(color: AppColors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'لا',
                style: AppTextStyles.bold_12.copyWith(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete(); // استدعي الدالة عند الموافقة
              },
              child: Text(
                'نعم',
                style: AppTextStyles.bold_12.copyWith(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum AppointmentStatus {
  done,
  canceled,
  missed,
}