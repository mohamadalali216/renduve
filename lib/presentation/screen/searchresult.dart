
import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
import 'package:randevu_app/presentation/widget/paitent_item.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () {},
        ),
        title: const Text(
          "Search Result",
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
          icon: const Icon(Icons.qr_code_scanner, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PatientItemWidget(
                    number: "2",
                    name: "Ahmed Lutfi",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                  const SizedBox(height: 10),
                  PatientItemWidget(
                    number: "3",
                    name: "Saif Ali",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                  const SizedBox(height: 10),
                  PatientItemWidget(
                    number: "1",
                    name: "M. Abdo",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                  const SizedBox(height: 10),
                  PatientItemWidget(
                    number: "1",
                    name: "Alaa Nedim",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                  const SizedBox(height: 10),
                  PatientItemWidget(
                    number: "7",
                    name: "Fatima Asaad",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                  const SizedBox(height: 10),
                  PatientItemWidget(
                    number: "2",
                    name: "KH. Hasan",
                    id: "33105146236",
                    date: "15.9.2024",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// NEW PATIENT BUTTON
            SizedBox(
              width: double.infinity,
              child: CustomButton.textWithIcon(
                    text: "New Patient",
                    icon: Icons.add_circle_rounded,
                    onPressed: () {},
                    color: AppColors.primary,
                    textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
                    iconColor: AppColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

}