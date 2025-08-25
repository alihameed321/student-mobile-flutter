import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/dashboard_stats.dart';
import '../../../domain/usecases/get_dashboard_stats.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;

  DashboardBloc({
    required this.getDashboardStats,
  }) : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<RefreshDashboardStats>(_onRefreshDashboardStats);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (state is! DashboardLoaded || event.isRefresh) {
        emit(DashboardLoading());
      }

      final dashboardStats = await getDashboardStats();
      emit(DashboardLoaded(dashboardStats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboardStats(
    RefreshDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboardStats(isRefresh: true));
  }
}