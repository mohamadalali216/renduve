import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_event.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_state.dart';
import 'package:randevu_app/presentation/routes/app_router.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';
import 'package:randevu_app/presentation/widget/custom_textfild.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';

class NewPatientScreen extends StatefulWidget {
final int doctorId;
  const NewPatientScreen({super.key, required this.doctorId});

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  String? selectedGender;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  void _onSavePatient() {
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar("Please enter patient name");
      return;
    }

    context.read<PatientBloc>().add(
      AddPatientEvent(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        city: _cityController.text.trim().isNotEmpty ? _cityController.text.trim() : null,
        address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
        age: _ageController.text.trim().isNotEmpty ? int.tryParse(_ageController.text.trim()) : null,
        idNumber: _idNumberController.text.trim().isNotEmpty ? _idNumberController.text.trim() : null,
        gender: selectedGender,
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _phoneController.clear();
    _cityController.clear();
    _addressController.clear();
    _ageController.clear();
    _idNumberController.clear();
    selectedGender = null;
  }
   /// Validation Helper Methods
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
bool _validateAllFields() {
  final name = _nameController.text.trim();
  final phone = _phoneController.text.trim();
  final city = _cityController.text.trim();
  final address = _addressController.text.trim();
  final ageText = _ageController.text.trim();
  final idNumber = _idNumberController.text.trim();
  // 1) Full Name (عربي + إنكليزي + مسافات)
 if (name.isEmpty || !RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$').hasMatch(name)) {
    _showError("الاسم يجب أن يحتوي على أحرف عربية أو إنكليزية ومسافات فقط");
    return false;
  }

  // 2) Phone Number (أرقام فقط – الحد الأدنى 16 رقم)
  if (phone.length >16) {
    _showError("رقم الهاتف يجب أن يكون أقل من 16 خانة");
    return false;
  }
  if (!RegExp(r'^\d+$').hasMatch(phone)) {
    _showError("رقم الهاتف يجب أن يحتوي على أرقام فقط");
    return false;
  }

  // 3) City (عربي + إنكليزي + مسافات)
  if (city.isEmpty || !RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$').hasMatch(city)) {
    _showError("المدينة يجب أن تحتوي على أحرف عربية أو إنكليزية ومسافات فقط");
    return false;
  }

  // 4) Address (عربي + إنكليزي + مسافات)
  if (address.isEmpty || !RegExp(r'^[a-zA-Z\u0600-\u06FF ]+$').hasMatch(address)) {
    _showError("العنوان يجب أن يحتوي على أحرف عربية أو إنكليزية ومسافات فقط");
    return false;
  }

  // 5) Age (رقم موجب أصغر من 120)
  final age = int.tryParse(ageText) ?? 0;
  if (age <= 0 || age > 120) {
    _showError("العمر يجب أن يكون بين 1 و 120");
    return false;
  }

  // 6) ID Number (11 رقم فقط)
  if (idNumber.length != 11) {
    _showError("رقم الهوية يجب أن يكون 11 رقماً");
    return false;
  }
  if (!RegExp(r'^\d{11}$').hasMatch(idNumber)) {
    _showError("رقم الهوية يجب أن يحتوي على أرقام فقط");
    return false;
  }

  return true; // كل شيء صحيح
}

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
        // ✅ P0.1 FIX: Add listenWhen to prevent multiple triggers
        listenWhen: (prev, curr) {
          // Only trigger when PatientSuccess is NEW - prevents state replay issues
          if (prev is PatientSuccess && curr is PatientSuccess) {
            return prev.patientId != curr.patientId;
          }
          return prev.runtimeType != curr.runtimeType;
        },
        listener: (context, state) {
          // ✅ Add mounted check for safety
          if (!mounted) return;

        if (state is PatientSuccess) {
  _showSnackBar("Patient saved successfully!", isSuccess: true);
context.read<AppointmentBloc>().add(
    SetDoctorEvent(widget.doctorId),
  );
  context.read<AppointmentBloc>().add(
    SetPatientEvent(state.patientId),
  );
  _clearFields();

  context.read<AppointmentBloc>().add(ValidateSelectionEvent());
Navigator.pushReplacementNamed(context, AppRoutes.appointmenttake);
} else if (state is PatientFailure) {
            _showSnackBar(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is PatientLoading;
          
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                onPressed: () {  Navigator.pop(context);},
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
                    backgroundColor: AppColors.grayLight2,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),

                  /// PHONE
                  _label("Phone Number (WhatsApp)", icon: Icons.phone),
                  CustomTextField.normal(
                    hint: "Enter Patient Phone Number",
                    backgroundColor: AppColors.grayLight2,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 16),

                  /// CITY
                  _label("City", icon: Icons.location_city),
                  CustomTextField.normal(
                    hint: "Enter Patient City",
                    backgroundColor: AppColors.grayLight2,
                    controller: _cityController,
                  ),
                  const SizedBox(height: 16),

                  /// ADDRESS
                  _label("Address", icon: Icons.home),
                  CustomTextField.normal(
                    hint: "Enter Patient Address",
                    backgroundColor: AppColors.grayLight2,
                    controller: _addressController,
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
                              backgroundColor: AppColors.grayLight2,
                              keyboardType: TextInputType.number,
                              controller: _ageController,
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
                              backgroundColor: AppColors.grayLight2,
                              keyboardType: TextInputType.number,
                              controller: _idNumberController,
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
                    backgroundColor: AppColors.grayLight2,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 30),

                  /// BUTTONS
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton.text(
                            text: isLoading ? "Saving..." : "Save Without Appointment",
  onPressed: () {
    if (!isLoading) {
      if (_validateAllFields()) {
        _onSavePatient();
      }
    }
  },
                            color: AppColors.black,
                            textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                    /*  SizedBox(
                          width: double.infinity,
                          child: CustomButton.textWithIcon(
                            text: "Add Appointment",
                            icon: Icons.add_circle_rounded,
                            onPressed: () => AppRouter.navigateTo(context, AppRoutes.appointmenttake),
                            color: AppColors.primary,
                            textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
                            iconColor: AppColors.white,
                          ),
                        ),*/
                      ],
                    ),
                ],
              ),
            ),
          );
        },
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

