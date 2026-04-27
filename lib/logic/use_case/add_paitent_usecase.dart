
import 'package:randevu_app/data/models/paitent_model.dart';
import 'package:randevu_app/data/repository/paitent_repository.dart';

/// ================= Interface =================
abstract class IAddPatientUseCase {
  Future<int> execute(PatientModel patient);
}

/// ================= Implementation =================
class AddPatientUseCase implements IAddPatientUseCase {
  final PatientRepository repository;

  AddPatientUseCase({required this.repository});

  @override
  Future<int> execute(PatientModel patient) async {

    // 🔥 Business Validation
    if (patient.name.trim().isEmpty) {
      throw Exception("Patient name cannot be empty");
    }

    return await repository.addPatient(patient);
  }
}