# 📝 Code Refactoring Examples

## Issue #1: Persistent Success Flag → Consumable Event

### BEFORE (appointment_state.dart)
```dart
class AppointmentState {
  final int? doctorId;
  final int? patientId;
  final bool isLoading;
  final bool isSuccess;  // ❌ PROBLEM: Persistent flag
  final bool isGetLoading;
  final String? error;
  final List<AppointmentModel> appointments;
  final bool isValid;
  final String? validationError;
  final DateTime? selectedDate;

  const AppointmentState({
    this.doctorId,
    this.patientId,
    this.isLoading = false,
    this.isSuccess = false,  // ❌ Starts false, stays true forever after success
    this.isGetLoading = false,
    this.error,
    this.appointments = const [],
    this.isValid = false,
    this.validationError,
    this.selectedDate,
  });

  AppointmentState copyWith({
    int? doctorId,
    int? patientId,
    bool? isLoading,
    bool? isSuccess,
    bool? isGetLoading,
    String? error,
    List<AppointmentModel>? appointments,
    bool? isValid,
    String? validationError,
    DateTime? selectedDate,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AppointmentState(
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: clearSuccess ? false : (isSuccess ?? this.isSuccess),
      // ❌ Even with clearSuccess, manually clearing is error-prone
      isGetLoading: isGetLoading ?? this.isGetLoading,
      error: clearError ? null : error ?? this.error,
      appointments: appointments ?? this.appointments,
      isValid: isValid ?? ((doctorId ?? this.doctorId) != null && (patientId ?? this.patientId) != null),
      validationError: validationError,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
```

### AFTER (appointment_state.dart)
```dart
import 'package:equatable/equatable.dart';

/// ✅ One-time event that auto-consumes after reading
class AppointmentCreatedEvent extends Equatable {
  final int appointmentId;
  final DateTime createdAt;
  final String date;
  final String time;
  final int doctorId;
  final int patientId;
  
  const AppointmentCreatedEvent({
    required this.appointmentId,
    required this.createdAt,
    required this.date,
    required this.time,
    required this.doctorId,
    required this.patientId,
  });
  
  @override
  List<Object?> get props => [appointmentId, createdAt, date, time, doctorId, patientId];
}

class AppointmentState {
  final int? doctorId;
  final int? patientId;
  final bool isLoading;
  final bool isGetLoading;
  final String? error;
  final List<AppointmentModel> appointments;
  final bool isValid;
  final String? validationError;
  final DateTime? selectedDate;
  
  // ✅ NEW: Transient event storage
  AppointmentCreatedEvent? _latestCreatedEvent;
  
  const AppointmentState({
    this.doctorId,
    this.patientId,
    this.isLoading = false,
    this.isGetLoading = false,
    this.error,
    this.appointments = const [],
    this.isValid = false,
    this.validationError,
    this.selectedDate,
    AppointmentCreatedEvent? latestCreatedEvent,
  }) : _latestCreatedEvent = latestCreatedEvent;

  // ✅ NEW: Accessor that returns event and nulls it out
  AppointmentCreatedEvent? consumeCreatedEvent() {
    final event = _latestCreatedEvent;
    _latestCreatedEvent = null;
    return event;
  }
  
  // ✅ NEW: Check if there's unconsumed event
  bool get hasUnconsumedCreatedEvent => _latestCreatedEvent != null;
  
  // ✅ NEW: Get event without consuming (for listenWhen)
  AppointmentCreatedEvent? get latestCreatedEvent => _latestCreatedEvent;

  AppointmentState copyWith({
    int? doctorId,
    int? patientId,
    bool? isLoading,
    bool? isGetLoading,
    String? error,
    List<AppointmentModel>? appointments,
    bool? isValid,
    String? validationError,
    DateTime? selectedDate,
    AppointmentCreatedEvent? newCreatedEvent,
    bool clearError = false,
    bool clearCreatedEvent = false,
  }) {
    return AppointmentState(
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      isLoading: isLoading ?? this.isLoading,
      isGetLoading: isGetLoading ?? this.isGetLoading,
      error: clearError ? null : error ?? this.error,
      appointments: appointments ?? this.appointments,
      isValid: isValid ?? ((doctorId ?? this.doctorId) != null && (patientId ?? this.patientId) != null),
      validationError: validationError,
      selectedDate: selectedDate ?? this.selectedDate,
      // ✅ Store new event or clear based on flag
      latestCreatedEvent: clearCreatedEvent 
          ? null 
          : (newCreatedEvent ?? this._latestCreatedEvent),
    );
  }
}
```

---

## Issue #2: Navigation in BlocListener → Navigation Service

### BEFORE (appointmenttake.dart)
```dart
BlocConsumer<AppointmentBloc, AppointmentState>(
  // ❌ Weak guard
  listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess && curr.isSuccess,
  listener: (context, state) {
    if (state.isSuccess && ModalRoute.of(context)?.isCurrent == true) {
      // ❌ Navigation directly in listener - tight coupling!
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
      // ❌ No error handling
      // ❌ No cleanup of state
    }
    
    if (state.error != null) {
      _showSnackBar(state.error!);
    }
  },
  builder: (context, state) {
    // ...
  },
)
```

### AFTER (appointmenttake.dart)
```dart
import 'package:randevu_app/core/navigation/app_navigator.dart';

BlocConsumer<AppointmentBloc, AppointmentState>(
  // ✅ Strong guard - only when event is NEW
  listenWhen: (prev, curr) {
    final prevHas = prev.latestCreatedEvent != null;
    final currHas = curr.latestCreatedEvent != null;
    return !prevHas && currHas && !curr.isLoading && curr.error == null;
  },
  listener: (context, state) async {
    // ✅ Safety checks
    if (!mounted) return;
    
    // ✅ Check screen is current
    if (ModalRoute.of(context)?.isCurrent != true) return;
    
    final event = state.latestCreatedEvent;
    if (event == null) return;
    
    try {
      // ✅ Use navigation service
      final navigator = AppNavigator(context);
      
      await navigator.toAppointmentConfirmation(
        doctorId: event.doctorId,
        patientId: event.patientId,
        date: event.date,
        time: event.time,
        notes: _notesController.text.trim(),
      );
      
      // ✅ IMPORTANT: Clear event after successful navigation
      // This prevents replay if user comes back
      if (mounted) {
        context.read<AppointmentBloc>().add(
          ClearAppointmentCreatedEvent(),
        );
      }
    } catch (e) {
      // ✅ Error handling
      _showSnackBar('Navigation error: $e');
    }
    
    if (state.error != null && mounted) {
      _showSnackBar(state.error!);
    }
  },
  builder: (context, state) {
    // ...
  },
)
```

### AFTER (app_navigation.dart - New File)
```dart
import 'package:flutter/material.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';

/// Navigation Service Layer
/// Decouples navigation from UI components
class AppNavigator {
  final BuildContext context;
  
  AppNavigator(this.context);
  
  /// Navigate to appointment confirmation
  Future<T?> toAppointmentConfirmation({
    required int doctorId,
    required int patientId,
    required String date,
    required String time,
    String? notes,
  }) {
    return Navigator.pushNamed<T>(
      context,
      AppRoutes.fAppointment,
      arguments: {
        'doctorId': doctorId,
        'patientId': patientId,
        'date': date,
        'time': time,
        'notes': notes,
      },
    );
  }
  
  /// Navigate to appointment booking
  Future<T?> toAppointmentBooking() {
    return Navigator.pushNamed<T>(
      context,
      AppRoutes.appointmenttake,
    );
  }
  
  /// Navigate to new patient with doctor context
  Future<T?> toNewPatient(int doctorId) {
    return Navigator.pushNamed<T>(
      context,
      AppRoutes.newPaitent,
      arguments: doctorId,
    );
  }
  
  /// Replace current with appointment booking
  void replaceWithAppointmentBooking(int doctorId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.appointmenttake,
      arguments: doctorId,
    );
  }
  
  /// Pop current screen
  void pop<T>([T? result]) {
    Navigator.pop<T>(context, result);
  }
}
```

---

## Issue #3: Global Bloc → Feature-Scoped (Comparison)

### BEFORE: Single Global Bloc (main.dart)
```dart
// All app uses same global instance
BlocProvider<AppointmentBloc>(
  create: (context) => AppointmentBloc(
    context.read<AppointmentRepository>(),
  ),
)

// Screen 1 - Uses global state
class AppointmentTakeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppointmentBloc>().state;
    // ❌ Reads/writes global state
    final doctorId = state.doctorId;
    final patientId = state.patientId;
    // ...
  }
}

// Screen 2 - Also uses same global state
class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppointmentBloc>().state;
    // ❌ Same global state, conflicts possible
    final doctorId = state.doctorId;
    // ...
  }
}
```

### AFTER: Feature-Scoped Providers
```dart
// main.dart - Feature-scoped providers
MultiBlocProvider(
  providers: [
    // ✅ Feature 1: Doctor Selection (global context)
    BlocProvider<DoctorSelectionBloc>(
      create: (context) => DoctorSelectionBloc(
        repository: context.read<DoctorRepository>(),
      ),
    ),
    
    // ✅ Feature 2: Patient Selection (global context)
    BlocProvider<PatientSelectionBloc>(
      create: (context) => PatientSelectionBloc(
        repository: context.read<PatientRepository>(),
      ),
    ),
    
    // ✅ Feature 3: Appointment Flow (scoped per feature)
    BlocProvider<AppointmentFlowBloc>(
      create: (context) => AppointmentFlowBloc(
        repository: context.read<AppointmentRepository>(),
        doctorSelection: context.read<DoctorSelectionBloc>(),
        patientSelection: context.read<PatientSelectionBloc>(),
      ),
    ),
  ],
)

// screen_appointment_flow.dart - Scoped bloc
class AppointmentTakeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Uses feature-scoped bloc
    final flowBloc = context.watch<AppointmentFlowBloc>();
    final doctorSelection = context.watch<DoctorSelectionBloc>();
    // Each feature has its own state management
    // ...
  }
}
```

---

## Issue #4: New Patient Screen Navigation

### BEFORE (newpaitent.dart)
```dart
BlocConsumer<PatientBloc, PatientState>(
  // ✅ Better guard but still has issues
  listenWhen: (prev, curr) {
    if (prev is PatientSuccess && curr is PatientSuccess) {
      return prev.patientId != curr.patientId;
    }
    return prev.runtimeType != curr.runtimeType;
  },
  listener: (context, state) {
    if (state is PatientSuccess) {
      _showSnackBar("Patient saved successfully!", isSuccess: true);
      
      // Set doctor/patient in AppointmentBloc
      context.read<AppointmentBloc>().add(SetDoctorEvent(widget.doctorId));
      context.read<AppointmentBloc>().add(SetPatientEvent(state.patientId));
      context.read<AppointmentBloc>().add(ValidateSelectionEvent());
      
      // ❌ Direct navigation - tight coupling
      Navigator.pushReplacementNamed(context, AppRoutes.appointmenttake);
      // ❌ No cleanup of patient state
    }
    
    if (state is PatientFailure) {
      _showSnackBar(state.message);
    }
  },
)
```

### AFTER (newpaitent.dart)
```dart
BlocConsumer<PatientBloc, PatientState>(
  listenWhen: (prev, curr) {
    // Only trigger on NEW success, not replay
    if (prev is PatientSuccess && curr is PatientSuccess) {
      return prev.patientId != curr.patientId;
    }
    return prev.runtimeType != curr.runtimeType;
  },
  listener: (context, state) async {
    if (!mounted) return;
    
    if (state is PatientSuccess) {
      _showSnackBar("Patient saved successfully!", isSuccess: true);
      
      // Update doctor/patient selection
      final appointmentBloc = context.read<AppointmentBloc>();
      appointmentBloc.add(SetDoctorEvent(widget.doctorId));
      appointmentBloc.add(SetPatientEvent(state.patientId));
      appointmentBloc.add(ValidateSelectionEvent());
      
      // ✅ Use navigation service
      final navigator = AppNavigator(context);
      navigator.replaceWithAppointmentBooking(widget.doctorId);
      
      // ✅ Clear patient success state to prevent replay
      context.read<PatientBloc>().add(ClearPatientSuccessEvent());
    }
    
    if (state is PatientFailure && mounted) {
      _showSnackBar(state.message);
    }
  },
)
```

---

## Summary: Key Changes Overview

| Issue | Before | After |
|-------|--------|-------|
| **Success Flag** | `bool isSuccess` (persistent) | `AppointmentCreatedEvent?` (consumable) |
| **Navigation** | `Navigator.pushNamed` in listener | `AppNavigator` service layer |
| **Bloc Scope** | Single global `AppointmentBloc` | Feature-scoped blocs |
| **State Clear** | Manual (error-prone) | Auto-consume pattern |
| **listenWhen** | Weak (`prev != curr`) | Strong (specific conditions) |

---

## 🎯 Implementation Priority

1. **Immediate**: Replace `isSuccess` with consumable event
2. **Day 1**: Extract `AppNavigator` service
3. **Day 2**: Add event clear mechanism
4. **Week 2**: Consider feature-scoped bloc refactor

Each change is backwards compatible and can be applied incrementally.
