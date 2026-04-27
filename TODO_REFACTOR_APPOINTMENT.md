# Refactor AddAppointmentScreen – TODO

## Plan
- [x] 1. Analyze current code and related bloc/model files
- [x] 2. Move MultiBlocListener outside BlocConsumer
- [x] 3. Fix null safety – remove `!` on doctorId/patientId, add explicit checks
- [x] 4. Replace `int.parse` with `int.tryParse` everywhere + add `_parseIntSafely`
- [x] 5. Unify date/time logic – single source of truth via `_buildDate()` / `_buildTime()`
- [x] 6. Centralize AM/PM conversion in `_convertTo24Hour` helper
- [x] 7. Clean PatientBloc listener – flatten logic, remove redundant checks
- [x] 8. Improve UX – add `_isFormReady()`, disable save for invalid data, show parsing errors
- [x] 9. Split UI into helper methods (`_buildDateSection`, `_buildTimeSection`, etc.)
- [x] 10. Run `flutter analyze` to verify no static errors

