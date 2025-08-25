import '../entities/student_document.dart';
import '../repositories/student_portal_repository.dart';

class GetStudentDocuments {
  final StudentPortalRepository repository;

  GetStudentDocuments(this.repository);

  Future<List<StudentDocument>> call({
    String? documentType,
    String? search,
    int? page,
  }) async {
    return await repository.getStudentDocuments(
      documentType: documentType,
      search: search,
      page: page,
    );
  }
}

class GetStudentDocumentDetail {
  final StudentPortalRepository repository;

  GetStudentDocumentDetail(this.repository);

  Future<StudentDocument> call(int id) async {
    return await repository.getStudentDocumentDetail(id);
  }
}