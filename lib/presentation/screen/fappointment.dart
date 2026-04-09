import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
class FinishAppointmentScreen extends StatelessWidget {
  const FinishAppointmentScreen({super.key});

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
          "Finish Appointment",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// DOCTOR
            _title("Doctor"),
            const SizedBox(height: 6),
            _blackTag("Toka Farawati"),

            const SizedBox(height: 20),

            /// PATIENT INFO ROW 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn("Full Name", "Abdullah Alabboud"),
                _infoColumn("Age", "29"),
                _infoColumn("Gender", "M"),
              ],
            ),

            const SizedBox(height: 16),

            /// PATIENT INFO ROW 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn("City", "Idleb"),
                _infoColumn("ID Number", "334628624659"),
              ],
            ),

            const SizedBox(height: 16),

            /// PHONE
            _infoColumn("Phone Number", "3528610044"),

            const SizedBox(height: 20),

            /// DATE & TIME
            Row(
              children: [
                Expanded(
                  child: _greenBox("Date", "3528610044"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _greenBox("Time", "6:30 PM"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NOTES
            _title("Notes"),
            const SizedBox(height: 8),

            Text(
              "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
              style: AppTextStyles.bold_12
                  .copyWith(color: AppColors.white),
            ),

            const Spacer(),

            /// SEND BUTTON
            SizedBox(
              width: double.infinity,
              child: CustomButton.text(
                text: "Send Appointment PDF By WP",
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

  /// ================= WIDGETS =================

  Widget _title(String text) {
    return Text(
      text,
      style: AppTextStyles.bold_16
          .copyWith(color: AppColors.primary),
    );
  }

  Widget _blackTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.bold_16
            .copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _greenBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bold_16
              .copyWith(color: AppColors.white),
          ),
      ],
    );
  }
}