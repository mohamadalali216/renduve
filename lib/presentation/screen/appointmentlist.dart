import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/appointment_item.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
// ← هذا هو الودجت الجديد الذي أنشأناه

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> appointments = [
      {
        "time": "6:30 PM",
        "name": "Ahmed Lutfi",
        "id": "33105146236",
        "date": "15.9.2024",
        "status": AppointmentStatus.done,
      },
      {
        "time": "6:40 PM",
        "name": "Saif Ali",
        "id": "33105146236",
        "date": "15.9.2024",
        "status": AppointmentStatus.canceled,
      },
      {
        "time": "7:10 PM",
        "name": "Alaa Nedim",
        "id": "33105146236",
        "date": "15.9.2024",
        "status": AppointmentStatus.missed,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.gray,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () {},
        ),
        title: const Text(
          "Appointments List",
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),

      bottomNavigationBar: FlexibleBar(
        backgroundColor: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        leftWidget: IconButton(
          icon: const Icon(Icons.person_search_rounded, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu_open_outlined, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// DATE HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                const SizedBox(width: 8),
                Text(
                  "15.9.2024",
                  style: AppTextStyles.bold_10.copyWith(color: AppColors.white),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: AppColors.white),
              ],
            ),

            const SizedBox(height: 20),

            /// APPOINTMENTS LIST
            Expanded(
              child: ListView.separated(
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 3),
                itemBuilder: (context, index) {
                  final item = appointments[index];
                  return AppointmentItemWidget(
                    time: item["time"],
                    name: item["name"],
                    id: item["id"],
                    lastDate: item["date"],
                    status: item["status"],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
