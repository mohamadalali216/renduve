# 🗂️ Professional Architecture Refactor Plan

## Phase-Based Implementation Guide

---

## 📌 Phase 1: Fix Critical State Issues (Immediate)

### Step 1.1: Convert Persistent Success Flag to Consumable Event
**File**: `lib/logic/appointment_bloc/appointment_state.dart`

**Goal**: Convert `isSuccess` from persistent boolean to one-time event mechanism

**BEFORE**:
```dart
class AppointmentState {
  final bool isSuccess = false;
  
  AppointmentState copyWith({
    bool? isSuccess,
  }) {
    return AppointmentState(
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
```

**AFTER**:
```dart
/// One-time event wrapper that auto-consumes after reading
class AppointmentCreatedEvent {
  final int appointmentId;
  final DateTime createdAt;
  final bool _consumed = false;
  
  AppointmentCreatedEvent({required this.appointmentId});
  
  bool get isUnconsumed => !_consumed;
}

class AppointmentState {
  // 🔄 REPLACED: Consumable one-time event instead of persistent flag
  final List<AppointmentCreatedEvent> _createdEvents = [];
  
  // Only access latest unconsumed event
  AppointmentCreatedEvent? get lastCreatedEvent => 
      _createdEvents.isNotEmpty ? _createdEvents.last : null;
  
  AppointmentState copyWith({
    AppointmentCreatedEvent? newAppointmentCreated,
    bool clearLatestEvent = false,
  }) {
    final newEvents = List<AppointmentCreatedEvent>.from(_createdEvents);
    
    if (newAppointmentCreated != null) {
      newEvents.add(newAppointmentCreated);
    }
    
    if (clearLatestEvent && newEvents.isNotEmpty) {
      newEvents.removeLast();
    }
    
    return AppointmentState._internal(
      createdEvents: UnmodifiableListView(newEvents),
    );
  }
  
  // Private constructor
  AppointmentState._internal({required List<AppointmentCreatedEvent> createdEvents})
      : _createdEvents = createdEvents;
}
```

---

### Step 1.2: Update AppointmentBloc to Use New Event Mechanism
**File**: `lib/logic/appointment_bloc/appointment_bloc.dart`

**BEFORE**:
```dart
Future<void> _onAddAppointment(
  AddAppointmentEvent event,
  Emitter<AppointmentState> emit,
) async {
  emit(state.copyWith(isLoading: true, error: null));

  try {
    await appointmentRepository.addAppointment(appointment);

    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,  // ❌ Persistent flag
      error: null,
    ));
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
```

**AFTER**:
```dart
Future<void> _onAddAppointment(
  AddAppointmentEvent event,
  Emitter<AppointmentState> emit,
) async {
  emit(state.copyWith(isLoading: true, error: null));

  try {
    final newId = await appointmentRepository.addAppointment(appointment);

    // ✅ NEW: Create consumable one-time event
    emit(state.copyWith(
      isLoading: false,
      newAppointmentCreated: AppointmentCreatedEvent(
        appointmentId: newId,
        createdAt: DateTime.now(),
      ),
      error: null,
    ));
    
    // ⚠️ IMPORTANT: Must clear after navigation completes
    // This should be called from UI after navigation is successful
  } catch (e) {
    emit(state.copyWith(
      isLoading: false,
      error: e.toString(),
    ));
  }
}
```

---

### Step 1.3: Add Clear Mechanism to AppointmentState
**File**: `lib/logic/appointment_bloc/appointment_state.dart`

Add method to consume/clear the event after handling:

```dart
/// Consumes the latest created event (call after successful navigation)
AppointmentState consumeCreatedEvent() {
  if (_createdEvents.isEmpty) return this;
  
  final newEvents = List<AppointmentCreatedEvent>.from(_createdEvents);
  final latestEvent = newEvents.removeLast();
  
  // Mark as consumed
  // latestEvent._consume();
  
  return AppointmentState._internal(
    createdEvents: UnmodifiableListView(newEvents),
  );
}

/// Check if there's unconsumed event without consuming
bool hasUnconsumedCreatedEvent() {
  return _createdEvents.isNotEmpty;
}
```

---

## 📌 Phase 2: Extract Navigation Layer (High Priority)

### Step 2.1: Create Navigation Service
**File**: `lib/core/navigation/app_navigator.dart`

```dart
import 'package:flutter/material.dart';
import 'package:randevu_app/presentation/routes/app_routes.dart';

/// 🚀 Navigation Service Layer
/// Decouples navigation from Bloc and UI components
class AppNavigator {
  final BuildContext context;
  
  AppNavigator(this.context);
  
  /// Navigate to appointment confirmation screen
  Future<T?> toAppointmentConfirmation({
    required int doctorId,
    required int patientId,
    required String date,
    required String time,
    String? notes,
  }) {
    return Navigator.pushNamed(
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
  
  /// Navigate to appointment booking flow
  Future<T?> toAppointmentBooking() {
    return Navigator.pushNamed(
      context,
      AppRoutes.appointmenttake,
    );
  }
  
  /// Navigate to new patient registration
  Future<T?> toNewPatient(int doctorId) {
    return Navigator.pushNamed(
      context,
      AppRoutes.newPaitent,
      arguments: doctorId,
    );
  }
  
  /// Replace current screen with appointment booking
  void replaceWithAppointmentBooking(int doctorId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.appointmenttake,
      arguments: doctorId,
    );
  }
  
  /// Pop current screen
  void pop<T>([T? result]) {
    Navigator.pop(context, result);
  }
  
  /// Pop to first screen in stack
  void popToFirst() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
```

---

### Step 2.2: Refactor appointmenttake.dart to Use Navigation Service
**File**: `lib/presentation/screen/appointmenttake.dart`

**BEFORE**:
```dart
BlocConsumer<AppointmentBloc, AppointmentState>(
  listener: _onAppointmentStateChange,
  // ...
)

void _onAppointmentStateChange(BuildContext context, AppointmentState state) {
  if (state.isSuccess && ModalRoute.of(context)?.isCurrent == true) {
    Navigator.pushNamed(
      context,
      AppRoutes.fAppointment,
      arguments: {...},
    );
  }
}
```

**AFTER**:
```dart
BlocConsumer<AppointmentBloc, AppointmentState>(
  // ✅ IMPROVED: More specific guard
  listenWhen: (prev, curr) {
    // Only trigger when there's NEW unconsumed event
    final prevHasEvent = prev.lastCreatedEvent?.isUnconsumed ?? false;
    final currHasEvent = curr.lastCreatedEvent?.isUnconsumed ?? false;
    return !prevHasEvent && currHasEvent;
  },
  listener: _onAppointmentCreated,
  // ...
)

Future<void> _onAppointmentCreated(
  BuildContext context, 
  AppointmentState state,
) async {
  // ✅ Safety check
  if (!mounted) return;
  
  // Only proceed if this is the current screen
  if (ModalRoute.of(context)?.isCurrent != true) return;
  
  final event = state.lastCreatedEvent;
  if (event == null || !event.isUnconsumed) return;
  
  // Use navigation service
  final navigator = AppNavigator(context);
  
  await navigator.toAppointmentConfirmation(
    doctorId: state.doctorId!,
    patientId: state.patientId!,
    date: _buildDate()!,
    time: _buildTime()!,
    notes: _notesController.text.trim(),
  );
  
  // ✅ CRITICAL: Clear the event after successful navigation
  context.read<AppointmentBloc>().add(ClearAppointmentCreatedEvent());
}
```

---

### Step 2.3: Create Clear Event for AppointmentBloc
**File**: `lib/logic/appointment_bloc/appointment_event.dart`

```dart
/// Event to clear the created appointment event after navigation
class ClearAppointmentCreatedEvent extends AppointmentEvent {}
```

**File**: `lib/logic/appointment_bloc/appointment_bloc.dart`

```dart
on<ClearAppointmentCreatedEvent>((event, emit) {
  emit(state.consumeCreatedEvent());
});
```

---

## 📌 Phase 3: Refactor Global Bloc (Architecture Level)

### Step 3.1: Split AppointmentBloc Responsibilities
**Current Problem**: Single Bloc manages:
1. Doctor selection (app-wide)
2. Patient selection (app-wide)
3. Form validation
4. Appointment CRUD
5. Date navigation
6. Session state

**Solution**: Split into feature-scoped BLoCs

### Option A: Feature-Based Scoped Blocs (Recommended)

Create separate blocs for each feature:

```
lib/logic/
├── appointment_flow/          # NEW: Feature-scoped
│   ├── appointment_flow_bloc.dart
│   ├── appointment_flow_event.dart
│   └── appointment_flow_state.dart
├── doctor_selection/           # NEW: Feature-scoped
│   ├── doctor_selection_bloc.dart
│   ├── doctor_selection_event.dart
│   └── doctor_selection_state.dart
├── patient_selection/         # NEW: Feature-scoped
│   ├── patient_selection_bloc.dart
│   ├── patient_selection_event.dart
│   └── patient_selection_state.dart
└── existing blocs...
```

### Option B: Keep Single Bloc with Clearer State (Faster)

If you want minimal changes, refactor current Bloc with clearer state separation:

**File**: `lib/logic/appointment_bloc/appointment_state.dart`

```dart
/// Separate UI state from data state
class AppointmentUIState {
  final int? selectedDoctorId;
  final int? selectedPatientId;
  final bool isFormValid;
  final String? validationMessage;
  
  // Form fields
  final DateTime? selectedDate;
  final String? notes;
  
  const AppointmentUIState({
    this.selectedDoctorId,
    this.selectedPatientId,
    this.isFormValid = false,
    this.validationMessage,
    this.selectedDate,
    this.notes,
  });
  
  AppointmentUIState copyWith({
    int? selectedDoctorId,
    int? selectedPatientId,
    bool? isFormValid,
    String? validationMessage,
    DateTime? selectedDate,
    String? notes,
  }) {...}
}

class AppointmentDataState {
  final List<AppointmentModel> appointments;
  final bool isLoading;
  final String? error;
  
  const AppointmentDataState({
    this.appointments = const [],
    this.isLoading = false,
    this.error,
  });
  
  // Getters
  bool get hasAppointments => appointments.isNotEmpty;
  int get appointmentCount => appointments.length;
}

class AppointmentState {
  final AppointmentUIState ui;
  final AppointmentDataState data;
  final List<AppointmentCreatedEvent> _createdEvents;
  
  const AppointmentState({
    this.ui = const AppointmentUIState(),
    this.data = const AppointmentDataState(),
    final List<AppointmentCreatedEvent>? createdEvents,
  }) : _createdEvents = createdEvents ?? [];
  
  // Convenience getters
  int? get doctorId => ui.selectedDoctorId;
  int? get patientId => ui.selectedPatientId;
  bool get isLoading => data.isLoading;
  List<AppointmentModel> get appointments => data.appointments;
  AppointmentCreatedEvent? get lastCreatedEvent => 
      _createdEvents.isNotEmpty ? _createdEvents.last : null;
}
```

---

## 📌 Phase 4: Add Safety Guards (All Screens)

### Step 4.1: Add Comprehensive listenWhen Guards

**Pattern for all BlocListeners/Consumers**:

```dart
BlocConsumer<AppointmentBloc, AppointmentState>(
  // ✅ Comprehensive guard
  listenWhen: (previousState, currentState) {
    // 1. Must have unconsumed event
    final currentHasEvent = currentState.lastCreatedEvent?.isUnconsumed ?? false;
    if (!currentHasEvent) return false;
    
    // 2. Previous state didn't have it
    final previousHasEvent = previousState.lastCreatedEvent?.isUnconsumed ?? false;
    if (previousHasEvent) return false;
    
    // 3. Not currently loading (avoid race)
    if (currentState.isLoading) return false;
    
    // 4. No error state
    if (currentState.error != null) return false;
    
    return true;
  },
  listener: _handleSuccess,
)
```

### Step 4.2: Add Screen Lifecycle Guards

```dart
@override
void initState() {
  super.initState();
  
  // Mark screen as active
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _isScreenActive = true;
  });
}

@override 
void dispose() {
  // Mark screen as inactive
  _isScreenActive = false;
  super.dispose();
}

bool _isScreenActive = false;

/// Guard helper
bool get _canHandleState => 
    mounted && 
    _isScreenActive && 
    ModalRoute.of(context)?.isCurrent == true;
```

---

## 📌 Safety Checklist

Before deploying, verify:

- [ ] No Navigator.push/pop in any BlocListener
- [ ] No persistent `isSuccess` flag usage
- [ ] All success states clear after consumption
- [ ] All listenWhen guards are specific
- [ ] All navigation goes through AppNavigator service
- [ ] No state replay on screen return
- [ ] No debug prints in production

---

## 🗓️ Implementation Order

```
Week 1:
├── Day 1-2: Phase 1 (State Fixes)
├── Day 3-4: Phase 2 (Navigation Layer)
└── Day 5:   Testing & Fixes

Week 2:
├── Day 1-2: Phase 3 (Bloc Refactor - Option B)
├── Day 3-4: Phase 4 (Safety Guards)
├── Day 5:   Integration Testing

Week 3:
├── Full Testing
├── Bug Fixes
└── Documentation
```

---

## ⚠️ Important Notes

1. **Minimal Changes First**: Start with Phase 1 & 2 before tackling Phase 3
2. **Test Each Change**: Build and test after each step
3. **Keep UI Unchanged**: Only internal architecture changes
4. **No Business Logic Changes**: Just refactoring, not feature changes
