import '../entities/dashboard_stats.dart';
import '../repositories/student_portal_repository.dart';

class GetDashboardStats {
  final StudentPortalRepository repository;

  GetDashboardStats(this.repository);

  Future<DashboardStats> call() async {
    return await repository.getDashboardStats();
  }
}