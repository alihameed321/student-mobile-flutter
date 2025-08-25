import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/financial/data/datasources/financial_api_service.dart';
import '../../features/financial/data/repositories/financial_repository_impl.dart';
import '../../features/financial/domain/repositories/financial_repository.dart';
import '../../features/financial/domain/usecases/get_financial_summary.dart';
import '../../features/financial/domain/usecases/get_student_fees.dart';
import '../../features/financial/domain/usecases/get_outstanding_fees.dart';
import '../../features/financial/domain/usecases/create_payment.dart';
import '../../features/financial/domain/usecases/get_payments.dart';
import '../../features/financial/domain/usecases/get_payment_providers.dart';
import '../../features/financial/presentation/bloc/financial_bloc.dart';
import '../../features/services/data/datasources/student_portal_api_service.dart';
import '../../features/services/data/repositories/student_portal_repository_impl.dart';
import '../../features/services/domain/repositories/student_portal_repository.dart';
import '../../features/services/domain/usecases/get_service_requests.dart';
import '../../features/services/domain/usecases/get_dashboard_stats.dart';
import '../../features/services/domain/usecases/support_ticket_usecases.dart';
import '../../features/services/domain/usecases/document_usecases.dart';
import '../../features/services/presentation/bloc/service_request/service_request_bloc.dart';
import '../../features/services/presentation/bloc/dashboard/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Core
  sl.registerLazySingleton(() => DioClient(sl()));
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FinancialApiService>(
    () => FinancialApiServiceImpl(sl()),
  );
  sl.registerLazySingleton<StudentPortalApiService>(
    () => StudentPortalApiServiceImpl(sl()),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<FinancialRepository>(
    () => FinancialRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StudentPortalRepository>(
    () => StudentPortalRepositoryImpl(sl()),
  );
  
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetFinancialSummary(sl()));
  sl.registerLazySingleton(() => GetStudentFees(sl()));
  sl.registerLazySingleton(() => GetOutstandingFees(sl()));
  sl.registerLazySingleton(() => CreatePayment(sl()));
  sl.registerLazySingleton(() => GetPayments(sl()));
  sl.registerLazySingleton(() => GetPaymentProviders(sl()));
  
  // Student Portal Use Cases
  sl.registerLazySingleton(() => GetServiceRequests(sl()));
  sl.registerLazySingleton(() => GetServiceRequestDetail(sl()));
  sl.registerLazySingleton(() => CreateServiceRequest(sl()));
  sl.registerLazySingleton(() => CancelServiceRequest(sl()));
  sl.registerLazySingleton(() => GetServiceRequestTypes(sl()));
  sl.registerLazySingleton(() => GetDashboardStats(sl()));
  sl.registerLazySingleton(() => GetSupportTickets(sl()));
  sl.registerLazySingleton(() => GetSupportTicketDetail(sl()));
  sl.registerLazySingleton(() => CreateSupportTicket(sl()));
  sl.registerLazySingleton(() => AddTicketResponse(sl()));
  sl.registerLazySingleton(() => GetTicketCategories(sl()));
  sl.registerLazySingleton(() => GetStudentDocuments(sl()));
  sl.registerLazySingleton(() => GetStudentDocumentDetail(sl()));
  
  // Blocs
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    logoutUseCase: sl(),
    getCurrentUserUseCase: sl(),
  ));
  sl.registerFactory(() => FinancialBloc(
    getFinancialSummary: sl(),
    getStudentFees: sl(),
    getOutstandingFees: sl(),
    createPayment: sl(),
    getPayments: sl(),
    getPaymentProviders: sl(),
  ));
  
  // Student Portal Blocs
  sl.registerFactory(() => ServiceRequestBloc(
    getServiceRequests: sl(),
    getServiceRequestDetail: sl(),
    createServiceRequest: sl(),
    cancelServiceRequest: sl(),
    getServiceRequestTypes: sl(),
  ));
  sl.registerFactory(() => DashboardBloc(
    getDashboardStats: sl(),
  ));
}