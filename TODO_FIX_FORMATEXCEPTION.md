# Fix FormatException in appointmenttake.dart

## Steps

- [x] 1. Read and analyze appointmenttake.dart
- [ ] 2. Refactor `_saveAppointment()` to use `_buildDate()` and `_buildTime()` instead of manual string construction
- [ ] 3. Add empty-date guards to save button (`day`, `month`, `year`)
- [ ] 4. Add defensive `if (newTime == null) return;` in `_setDefaultTime()`
- [ ] 5. Verify no `int.parse` remains in the file

