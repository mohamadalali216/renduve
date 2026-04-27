import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/data/models/doctor_model.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_state.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_bloc.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_event.dart';
import 'package:randevu_app/logic/doctor_bloc/doctor_state.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_event.dart';
import 'package:randevu_app/presentation/routes/app_router.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';
import 'package:randevu_app/presentation/screen/searchresult.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';

import 'package:randevu_app/presentation/widget/flexible_bar.dart';
import 'package:randevu_app/presentation/widget/userprofile.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final TextEditingController patientNameController = TextEditingController();

  List<DoctorModel> doctors = [];
  int? selectedDoctorId;
  String? selectedDoctor = null;
  bool doctorSelected = false;

  String patientQuery = "";

  @override
  void initState() {
    super.initState();

    context.read<DoctorBloc>().add(LoadDoctorsEvent());

    patientNameController.addListener(() {
      patientQuery = patientNameController.text.trim();
      print("LIVE TEXT = $patientQuery");
    });
  }

  @override
  void dispose() {
    patientNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.gray,
       appBar: AppBar(
        
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.notification_add, color: AppColors.white),
          onPressed: () {},
        ),
        title: const Center(child: 
         Text( 
          "Patient",
          style: TextStyle(color: AppColors.white,fontSize: 18),
        ),),
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

      body: BlocListener<AppointmentBloc, AppointmentState>(
        listenWhen: (prev, curr) => prev.patientId != curr.patientId,
        listener: (context, state) {
          if (state.patientId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Patient ${state.patientId} selected')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // بروفايل المريض
BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                return Center(
                  child: UserProfile(
                    name: state.patientId != null 
                      ? "Patient ID: ${state.patientId}" 
                      : "No Patient Selected",
                  ),
                );
              },
            ),
          
            const SizedBox(height: 16),
            /// DOCTOR LABEL
           Row(
                      children: [
                        Icon(Icons.heart_broken_outlined, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                           "Doctor",
                          style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    

            const SizedBox(height: 8),

            /// CUSTOM DROPDOWN
        BlocBuilder<DoctorBloc, DoctorState>(
  builder: (context, state) {
    if (state is DoctorLoading) {
      return const CircularProgressIndicator();
    }

    if (state is DoctorLoaded) {
      final doctors = state.doctors;
      final items = doctors.map((e) => e.name).toList();

      return Column(
        children: [
          CustomDropdown(
            value: selectedDoctor,
            items: items,
            onChanged: (value) {
              final doctor = doctors.firstWhere(
                (d) => d.name == value,
              );

              context.read<AppointmentBloc>().add(
                SetDoctorEvent(doctor.id!),
              );
              print("🎯 DOCTOR SELECTED & DISPATCHED: ${doctor.id}");
              setState(() {
                selectedDoctor = doctor.name;
                doctorSelected = true;
              });
            },
            width: 360,
            backgroundColor: AppColors.grayLight2,
          ),
          const SizedBox(height: 8),
          // Doctor status indicator
          BlocBuilder<AppointmentBloc, AppointmentState>(
            builder: (context, blocState) {
              final doctorName = blocState.doctorId != null ? (selectedDoctor ?? 'Doctor') : "No Doctor";
              final color = blocState.doctorId != null ? Colors.green : Colors.red;
              print("DROPDOWN BLOC: ${context.read<AppointmentBloc>().hashCode}");
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.medical_services, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      doctorName,
                      style: TextStyle(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    }

    return const Text("No Doctors Found");
  },
          ),
            const SizedBox(height: 20),

            /// PATIENT NAME FIELD
          TextField(
  onChanged: (value) {
    setState(() {
      patientQuery = value.trim();
    });
  },
  controller: patientNameController,
  decoration: InputDecoration(
    hintText: "Enter Patient Name",
    filled: true,
    fillColor: AppColors.grayLight2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
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
                 onPressed: () {
  final bloc = context.read<AppointmentBloc>();

  if (bloc.state.doctorId == null) return;
  if (patientQuery.isEmpty) return;

  context.read<PatientBloc>().add(SearchPatientEvent(patientQuery));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SearchResultScreen(),
    ),
  );
},
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
                    iconColor: AppColors.white,
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
            BlocBuilder<AppointmentBloc, AppointmentState>(
  builder: (context, state) {
    
    return SizedBox(
  width: double.infinity,
  child: CustomButton.textWithIcon(
    text: "New Patient",
    icon: Icons.add_circle_rounded,
    onPressed: () {
      final bloc = context.read<AppointmentBloc>();

      if (bloc.state.doctorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Please select a doctor first"),
          ),
        );
        return;
      }

      AppRouter.navigateTo(
        context,
        AppRoutes.newPaitent,
        arguments: bloc.state.doctorId,
      );
    },
    color: AppColors.primary,
    textStyle: AppTextStyles.bold_16.copyWith(
      color: AppColors.white,
    ),
    iconColor: AppColors.white,
  ),
);
  },
)
              ],
            ),
             
          ])    
        
  ) 
    
    ));
  }}