import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String? _selectedAmPm = "AM";
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Appointment",
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined,
                color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),

      /// ================= BOTTOM BAR =================
      bottomNavigationBar: FlexibleBar(
        backgroundColor: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        leftWidget: IconButton(
          icon: const Icon(Icons.group, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget: const SizedBox(),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// DATE
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Date",
                  style: AppTextStyles.bold_16
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _darkBoxField(_dayController, "DD"),
                _darkBoxField(_monthController, "MM"),
                _darkBoxField(_yearController, "YYYY"),
              ],
            ),

            const SizedBox(height: 10),

            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Or Next Day",
                    style: AppTextStyles.bold_12
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// TIME
            Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Time",
                  style: AppTextStyles.bold_16
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _darkBoxField(_hourController, "HH"),
                _darkBoxField(_minuteController, "MM"),
                _buildAmPmDropdown(),
              ],
            ),

            const SizedBox(height: 30),

            /// NOTES
            Row(
              children: [
                const Icon(Icons.edit_note, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Notes",
                  style: AppTextStyles.bold_16
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Some Note",
                  hintStyle: AppTextStyles.bold_12
                      .copyWith(color: AppColors.gray),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: CustomButton.text(
                text: "Save Appointment",
                onPressed: () {},
                color: AppColors.primary,
                textStyle: AppTextStyles.bold_16
                    .copyWith(color: AppColors.white),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  /// DARK BOX FIELD (EDITABLE DATE & TIME)
  Widget _darkBoxField(TextEditingController controller, String hint) {
    return Container(
      width: 90,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: AppTextStyles.bold_16.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bold_16.copyWith(color: AppColors.gray),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  /// AM/PM DROPDOWN
  Widget _buildAmPmDropdown() {
    return CustomDropdown(
      value: _selectedAmPm,
      items: const ["AM", "PM"],
      onChanged: (String? value) {
        setState(() {
          _selectedAmPm = value;
        });
      },
      height: 60,
      width: 80,
      borderRadius: 14,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
      iconColor: AppColors.white,
      borderColor: Colors.transparent,
    );
  }
}
