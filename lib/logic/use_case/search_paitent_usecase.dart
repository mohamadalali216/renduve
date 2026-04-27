
import 'package:randevu_app/data/models/paitent_model.dart';
import 'package:randevu_app/data/repository/paitent_repository.dart';

/// واجهة استخدام للبحث عن المرضى
abstract class ISearchPatientUseCase {
  Future<List<PatientModel>> execute({required String query});
}

/// التنفيذ الفعلي
class SearchPatientUseCase implements ISearchPatientUseCase {
  final PatientRepository repository;

  SearchPatientUseCase({required this.repository});

  @override
  Future<List<PatientModel>> execute({required String query}) async {
    if (query.isEmpty) {
      return await repository.getAllPatients();
    }
    return await repository.searchPatients(query);
  }
}
