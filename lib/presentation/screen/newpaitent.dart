import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';
import 'package:randevu_app/presentation/widget/custom_textfild.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({super.key});

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  String? selectedGender;

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
          "New Patient",
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
          icon: const Icon(Icons.person_search, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FULL NAME
            _label("Full Name", icon: Icons.person),
            CustomTextField.normal(
              hint: "Enter Patient Name",
              backgroundColor: AppColors.gray_light_2,
            ),
            const SizedBox(height: 16),

            /// PHONE
            _label("Phone Number (WhatsApp)", icon: Icons.phone),
            CustomTextField.normal(
              hint: "Enter Patient Phone Number",
              backgroundColor: AppColors.gray_light_2,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            /// CITY
            _label("City", icon: Icons.location_city),
            CustomTextField.normal(
              hint: "Enter Patient City",
              backgroundColor: AppColors.gray_light_2,
            ),
            const SizedBox(height: 16),

            /// ADDRESS
            _label("Address", icon: Icons.home),
            CustomTextField.normal(
              hint: "Enter Patient Address",
              backgroundColor: AppColors.gray_light_2,
            ),
            const SizedBox(height: 16),

            /// AGE + ID
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Age", icon: Icons.calendar_today),
                      CustomTextField.normal(
                        hint: "Age",
                        backgroundColor: AppColors.gray_light_2,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("ID Number", icon: Icons.credit_card),
                      CustomTextField.normal(
                        hint: "Enter ID Number",
                        backgroundColor: AppColors.gray_light_2,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// GENDER
            _label("Gender", icon: Icons.female),
            CustomDropdown(
              value: selectedGender,
              items: const ["Male", "Female"],
              onChanged: (v) => setState(() => selectedGender = v),
              backgroundColor: AppColors.gray_light_2,
              width: double.infinity,
            ),
            const SizedBox(height: 30),

            /// BUTTONS
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.text(
                    text: "Save Without Appointment",
                    onPressed: () {},
                    color: AppColors.black,
                    textStyle: const TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.textWithIcon(
                    text: "Add Appointment",
                    icon: Icons.add_circle_rounded,
                    onPressed: () {},
                    color: AppColors.primary,
                    textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
                    iconColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, {required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
