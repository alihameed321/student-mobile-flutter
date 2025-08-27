import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/academic_info.dart';
import '../../domain/usecases/get_academic_info.dart';

// Events
abstract class AcademicEvent extends Equatable {
  const AcademicEvent();

  @override
  List<Object> get props => [];
}

class LoadAcademicInfo extends AcademicEvent {
  final String studentId;

  const LoadAcademicInfo(this.studentId);

  @override
  List<Object> get props => [studentId];
}

class RefreshAcademicInfo extends AcademicEvent {
  final String studentId;

  const RefreshAcademicInfo(this.studentId);

  @override
  List<Object> get props => [studentId];
}

// States
abstract class AcademicState extends Equatable {
  const AcademicState();

  @override
  List<Object> get props => [];
}

class AcademicInitial extends AcademicState {}

class AcademicLoading extends AcademicState {}

class AcademicLoaded extends AcademicState {
  final AcademicInfo academicInfo;

  const AcademicLoaded(this.academicInfo);

  @override
  List<Object> get props => [academicInfo];
}

class AcademicError extends AcademicState {
  final String message;

  const AcademicError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AcademicBloc extends Bloc<AcademicEvent, AcademicState> {
  final GetAcademicInfo _getAcademicInfo;

  AcademicBloc(this._getAcademicInfo) : super(AcademicInitial()) {
    on<LoadAcademicInfo>(_onLoadAcademicInfo);
    on<RefreshAcademicInfo>(_onRefreshAcademicInfo);
  }

  Future<void> _onLoadAcademicInfo(
    LoadAcademicInfo event,
    Emitter<AcademicState> emit,
  ) async {
    emit(AcademicLoading());
    try {
      final academicInfo = await _getAcademicInfo(event.studentId);
      emit(AcademicLoaded(academicInfo));
    } catch (e) {
      emit(AcademicError(e.toString()));
    }
  }

  Future<void> _onRefreshAcademicInfo(
    RefreshAcademicInfo event,
    Emitter<AcademicState> emit,
  ) async {
    try {
      final academicInfo = await _getAcademicInfo(event.studentId);
      emit(AcademicLoaded(academicInfo));
    } catch (e) {
      emit(AcademicError(e.toString()));
    }
  }
}