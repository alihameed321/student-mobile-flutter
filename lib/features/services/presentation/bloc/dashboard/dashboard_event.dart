part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardEvent {
  final bool isRefresh;

  const LoadDashboardStats({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class RefreshDashboardStats extends DashboardEvent {
  const RefreshDashboardStats();
}