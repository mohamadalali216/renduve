import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:randevu_app/core/them/app_color.dart';
import 'package:randevu_app/core/them/app_font.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_bloc.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_event.dart';
import 'package:randevu_app/logic/appointment_bloc/appointment_state.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_bloc.dart';
import 'package:randevu_app/logic/paitent_bloc/paitent_state.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';
import 'package:randevu_app/presentation/widget/custom_button.dart';
import 'package:randevu_app/presentation/widget/custom_dropdown.dart';
import 'package:randevu_app/presentation/widget/flexible_bar.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  // ================= CONTROLLERS =================
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // ================= STATE =================
  String? _selectedAmPm = 'AM';

  final Map<String, bool> _fieldValid = {
    'day': true,
    'month': true,
    'year': true,
    'hour': true,
    'minute': true,
  };

  // ================= LIFECYCLE =================
 @override
void initState() {
  super.initState();

  _dayController.addListener(() => _validateField('day', _dayController.text));
  _monthController.addListener(() => _validateField('month', _monthController.text));
  _yearController.addListener(() => _validateField('year', _yearController.text));
  _hourController.addListener(() => _validateField('hour', _hourController.text));
  _minuteController.addListener(() => _validateField('minute', _minuteController.text));

  _setTodayDate();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _setDefaultTime(null); // أول تعبئة مباشرة

    final patientState = context.read<PatientBloc>().state;
    if (patientState is PatientAppointmentsLoaded) {
      _onPatientAppointmentsLoaded(context, patientState);
    }
  });
}

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

  // ================= HELPERS =================
  int? _parseIntSafely(String value) => int.tryParse(value.trim());

  // ================= DATE & TIME (Single Source of Truth) =================
  String? _buildDate() {
    final day = _dayController.text.trim();
    final month = _monthController.text.trim();
    final year = _yearController.text.trim();

    if (day.isEmpty || month.isEmpty || year.isEmpty) return null;

    final d = _parseIntSafely(day);
    final m = _parseIntSafely(month);
    final y = _parseIntSafely(year);

    if (d == null || m == null || y == null) return null;

    return '${y.toString()}-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
  }

  String? _buildTime() {
    final hourText = _hourController.text.trim();
    final minuteText = _minuteController.text.trim();

    if (hourText.isEmpty || minuteText.isEmpty) return null;

    final hour12 = _parseIntSafely(hourText);
    final minute = _parseIntSafely(minuteText);

    if (hour12 == null || minute == null) return null;

    final hour24 = _convertTo24Hour(hour12, _selectedAmPm ?? 'AM');
    return '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
  }

  int _convertTo24Hour(int hour12, String amPm) {
    var h = hour12;
    if (amPm == 'PM' && h != 12) h += 12;
    if (amPm == 'AM' && h == 12) h = 0;
    return h;
  }

  DateTime? _parseDateTimeFromControllers() {
    final y = _parseIntSafely(_yearController.text);
    final m = _parseIntSafely(_monthController.text);
    final d = _parseIntSafely(_dayController.text);

    if (y == null || m == null || d == null) return null;

    try {
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  bool _isFormReady() {
    if (_buildDate() == null || _buildTime() == null) return false;
    return _fieldValid.values.every((v) => v);
  }

  // ================= VALIDATION =================
  bool _isValidField(String field, String value) {
    if (value.isEmpty) return true;
    final number = _parseIntSafely(value);
    if (number == null) return false;
    switch (field) {
      case 'day':
        return number >= 1 && number <= 31;
      case 'month':
        return number >= 1 && number <= 12;
      case 'year':
        return value.length <= 4;
      case 'hour':
        return number >= 1 && number <= 12;
      case 'minute':
        return number >= 0 && number <= 59;
      default:
        return false;
    }
  }

  void _validateField(String field, String value) {
    final isValid = _isValidField(field, value);
    if (mounted) {
      setState(() {
        _fieldValid[field] = isValid;
      });
    }
  }

  // ================= DATE OPERATIONS =================
  void _setTodayDate() {
    final now = DateTime.now();
    _dayController.text = now.day.toString();
    _monthController.text = now.month.toString();
    _yearController.text = now.year.toString();
  }

  void _setNextDay() {
    final currentDate = _parseDateTimeFromControllers();
    if (currentDate == null) {
      _showSnackBar('Invalid date values');
      return;
    }

    final nextDay = currentDate.add(const Duration(days: 1));

    setState(() {
      _dayController.text = nextDay.day.toString();
      _monthController.text = nextDay.month.toString();
      _yearController.text = nextDay.year.toString();
    });
  }

  void _setDefaultTime(DateTime? lastAppointmentTime, {int addMinutes = 15}) {
  print("LAST APPOINTMENT: $lastAppointmentTime");

  // إذا ما في موعد سابق → استخدم الوقت الحالي
  final baseTime = lastAppointmentTime ?? DateTime.now();

  // إضافة الدقائق (افتراضي 15)
  final newTime = baseTime.add(Duration(minutes: addMinutes));

  int hour24 = newTime.hour;
  int minute = newTime.minute;

  String amPm = hour24 >= 12 ? 'PM' : 'AM';

  int hour12 = hour24 % 12;
  if (hour12 == 0) hour12 = 12;

  print("SET TIME CALLED");
  print("NEW BASE TIME: $newTime");
  print("Hour: $hour12");
  print("Minute: $minute");
  print("AM/PM: $amPm");

  if (!mounted) return;

  setState(() {
    _selectedAmPm = amPm;
    _hourController.text = hour12.toString();
    _minuteController.text = minute.toString().padLeft(2, '0');
  });
}
  // ================= SAVE APPOINTMENT =================
  void _saveAppointment() {
    final bloc = context.read<AppointmentBloc>();
    final state = bloc.state;

    final doctorId = state.doctorId;
    final patientId = state.patientId;

    if (doctorId == null || patientId == null) {
      _showSnackBar(state.validationError ?? 'Missing doctor or patient');
      return;
    }

    if (!state.isValid) {
      _showSnackBar(state.validationError ?? 'Missing doctor or patient');
      return;
    }

    final date = _buildDate();
    final time = _buildTime();

    if (date == null || time == null) {
      _showSnackBar('Please enter valid date and time');
      return;
    }

    bloc.add(
      AddAppointmentEvent(
        date: date,
        time: time,
        notes: _notesController.text.trim(),
        doctorId: doctorId,
        patientId: patientId,
      ),
    );
  }

  // ================= SNACKBAR =================
  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  // ================= BLOC LISTENERS =================
  void _onAppointmentStateChange(BuildContext context, AppointmentState state) {
    if (state.isSuccess) {
      _showSnackBar('Appointment saved successfully!', isSuccess: true);

      final date = _buildDate();
      final time = _buildTime();

      if (date != null && time != null) {
        Navigator.pushNamed(
          context,
          AppRoutes.fAppointment,
          arguments: {
            'doctorId': state.doctorId,
            'patientId': state.patientId,
            'date': date,
            'time': time,
            'notes': _notesController.text.trim(),
          },
        );
      }
    }

    if (state.error != null) {
      _showSnackBar(state.error!);
    }
  }

void _onPatientAppointmentsLoaded(
  BuildContext context,
  PatientAppointmentsLoaded pState,
) {
  final doctorId = context.read<AppointmentBloc>().state.doctorId;

  print("DOCTOR ID: $doctorId");
  print("Appointments Count: ${pState.appointments.length}");

  if (doctorId == null) {
    _setDefaultTime(null);
    return;
  }

  final doctorAppointments = pState.appointments.where((a) {
    print(
      "appt doctorId=${a.doctorId} patientId=${a.patientId} dateTime=${a.dateTime}",
    );

    return a.doctorId == doctorId && a.dateTime != null;
  }).toList();

  doctorAppointments.sort(
    (a, b) => b.dateTime!.compareTo(a.dateTime!),
  );

  if (doctorAppointments.isNotEmpty) {
    final last = doctorAppointments.first;

    print("LAST APPOINTMENT: ${last.dateTime}");

    _setDefaultTime(
      last.dateTime!,
      addMinutes: 15,
    );
  } else {
    print("NO APPOINTMENTS FOR THIS DOCTOR");
    _setDefaultTime(null);
  }
}

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PatientBloc, PatientState>(
          listenWhen: (prev, curr) => curr is PatientAppointmentsLoaded,
          listener: (context, pState) {
            if (pState is PatientAppointmentsLoaded) {
              _onPatientAppointmentsLoaded(context, pState);
            }
          },
        ),
      ],
      child: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: _onAppointmentStateChange,
        builder: (context, state) {
          final isLoading = state.isLoading;
          final canSave = state.isValid && _isFormReady() && !isLoading;

          return Scaffold(
            backgroundColor: AppColors.gray,

            /// ================= APP BAR =================
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Appointment',
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_active_outlined, color: AppColors.white),
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
                  _buildDateSection(),
                  const SizedBox(height: 30),
                  _buildTimeSection(),
                  const SizedBox(height: 30),
                  _buildNotesSection(),
                  const SizedBox(height: 30),
                  _buildSaveButton(state, canSave, isLoading),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UI SECTIONS =================
  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Date',
              style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _darkBoxField(_dayController, 'DD', 'day'),
            _darkBoxField(_monthController, 'MM', 'month'),
            _darkBoxField(_yearController, 'YYYY', 'year'),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: InkWell(
            onTap: _setNextDay,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Or Next Day',
                  style: AppTextStyles.bold_12.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Time',
              style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _darkBoxField(_hourController, 'HH', 'hour'),
            _darkBoxField(_minuteController, 'MM', 'minute'),
            _buildAmPmDropdown(),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.edit_note, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Notes',
              style: AppTextStyles.bold_16.copyWith(color: AppColors.primary),
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
              hintText: 'Some Note',
              hintStyle: AppTextStyles.bold_12.copyWith(color: AppColors.gray),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppointmentState state, bool canSave, bool isLoading) {
    return Column(
      children: [
        if (state.validationError != null || !_isFormReady())
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                state.validationError ?? 'Please fill in all date and time fields correctly',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: CustomButton.text(
            text: isLoading ? 'Saving...' : 'Save Appointment',
            onPressed: canSave ? _saveAppointment : null,
            color: canSave ? AppColors.primary : AppColors.gray,
            textStyle: AppTextStyles.bold_16.copyWith(color: AppColors.white),
          ),
        ),
      ],
    );
  }

  /// DARK BOX FIELD (EDITABLE DATE & TIME)
  Widget _darkBoxField(TextEditingController controller, String hint, String fieldKey) {
    final isValid = _fieldValid[fieldKey] ?? true;
    final errorColor = isValid ? null : Colors.red;
    return Container(
      width: 90,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: errorColor ?? Colors.transparent, width: 2),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: AppTextStyles.bold_16.copyWith(color: isValid ? AppColors.white : Colors.red),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isValid ? AppColors.gray : Colors.red,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        maxLength: fieldKey == 'year' ? 4 : 2,
      ),
    );
  }

  /// AM/PM DROPDOWN
  Widget _buildAmPmDropdown() {
    return CustomDropdown(
      value: _selectedAmPm ?? 'AM',
      items: const ['AM', 'PM'],
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            _selectedAmPm = value;
          });
        }
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

