import 'package:flutter/material.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';
import 'package:randevu_app/presentation/widget/custom_textfild.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';
import 'package:randevu_app/presentation/widget/userprofile.dart';


class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final TextEditingController patientNameController = TextEditingController();
  String? selectedDoctor = "Toka Farawati";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.notification_add, color: AppColors.white),
          onPressed: () {},
        ),
        title: const Center(child: 
         Text(
          "Patient",
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),)  ,
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
          icon: const Icon(Icons.person_3_rounded, color: AppColors.white),
          onPressed: () {},
        ),
        centerWidget:Text(" "),
        rightWidget: IconButton(
          icon: const Icon(Icons.menu_open_outlined, color: AppColors.white),
          onPressed: () {},
        ),
        height: 70,
      ),

      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بروفايل المريض
            const Center(
              child: UserProfile(
                name: "Patient Name",
              ),
            ),
          
            const SizedBox(height: 16),
        
          

         

            /// DOCTOR LABEL
           Row(
                      children: [
                        Icon(Icons.heart_broken, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                           "Doctor",
                          style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    

            const SizedBox(height: 8),

            /// CUSTOM DROPDOWN
            CustomDropdown(
              value: selectedDoctor,
              items: const [
                "Toka Farawati",
                "Mohammed Ali",
                "Sara Hasan",
              ],
              onChanged: (v) { setState(() { selectedDoctor = v; }); },
              backgroundColor:AppColors.gray_light_2,
              width: 360
            ,
            ),

            const SizedBox(height: 20),

            /// PATIENT NAME FIELD
            CustomTextField.normal(
              hint: "Enter Patient Name",
              backgroundColor:AppColors.gray_light_2,
            ),

            const SizedBox(height: 25),

            /// BUTTONS COLUMN
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.textWithIcon(
                    text: "Show Patients",
                    icon: Icons.people,
                    iconColor: AppColors.white,
                    onPressed: () {},
                    color:AppColors.primary,
                    textStyle: TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.textWithIcon(
                    text: "Former Patient",
                    icon: Icons.qr_code,
                    onPressed: () {},
                    color: AppColors.black,
                    textStyle: TextStyle(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "or",
                    style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 10),
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
             
          ])    
        
  ) 
    
    );
  }}