import '../../../../core/bloc/bloc_exports.dart';
import '../../data/reports_repository.dart';
import '../../domain/pet_report_model.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({ReportsRepository? reportsRepository})
      : _reportsRepository = reportsRepository ?? ReportsRepository.instance,
        super(const ReportsInitial());

  final ReportsRepository _reportsRepository;
  String? _currentUserId;

  /// Set current user ID
  void setUserId(String userId) {
    _currentUserId = userId;
  }

  /// Load all reports (public feed)
  Future<void> loadAllReports({
    PetReportType? filterType,
    PetReportStatus? filterStatus,
  }) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final reports = await _reportsRepository.getAllReports(
        filterType: filterType,
        filterStatus: filterStatus,
      );
      
      if (reports.isEmpty) {
        emit(const ReportsEmpty());
      } else {
        emit(ReportsLoaded(reports));
      }
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Load user's own reports
  Future<void> loadUserReports([String? userId]) async {
    final uid = userId ?? _currentUserId;
    if (uid == null) {
      emit(const ReportsError('Người dùng chưa đăng nhập'));
      return;
    }

    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final reports = await _reportsRepository.getUserReports(uid);
      
      if (reports.isEmpty) {
        emit(const ReportsEmpty());
      } else {
        emit(ReportsLoaded(reports));
      }
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Load single report by ID
  Future<void> loadReport(String reportId) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final report = await _reportsRepository.getReportById(reportId);
      
      if (report != null) {
        emit(ReportLoaded(report));
      } else {
        emit(const ReportsError('Không tìm thấy báo cáo'));
      }
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Create new report
  Future<void> createReport({
    required PetReportType type,
    required String petName,
    required String breed,
    required String locationLabel,
    required String description,
    required String contactInfo,
    String? photoUrl,
    double? latitude,
    double? longitude,
  }) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const ReportsError('Người dùng chưa đăng nhập'));
      return;
    }

    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final newReport = await _reportsRepository.createReport(
        type: type,
        petName: petName,
        breed: breed,
        locationLabel: locationLabel,
        description: description,
        contactInfo: contactInfo,
        photoUrl: photoUrl,
        latitude: latitude,
        longitude: longitude,
        ownerId: uid,
      );

      final message = type == PetReportType.lost 
          ? 'Đã đăng báo mất thú cưng' 
          : 'Đã đăng báo tìm thấy thú cưng';
      
      emit(ReportOperationSuccess(message, report: newReport));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Update existing report
  Future<void> updateReport(
    String reportId, {
    PetReportType? type,
    PetReportStatus? status,
    String? petName,
    String? breed,
    String? locationLabel,
    String? description,
    String? contactInfo,
    String? photoUrl,
    double? latitude,
    double? longitude,
  }) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final updatedReport = await _reportsRepository.updateReport(
        reportId,
        type: type,
        status: status,
        petName: petName,
        breed: breed,
        locationLabel: locationLabel,
        description: description,
        contactInfo: contactInfo,
        photoUrl: photoUrl,
        latitude: latitude,
        longitude: longitude,
      );

      emit(ReportOperationSuccess('Cập nhật báo cáo thành công', report: updatedReport));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Delete report
  Future<void> deleteReport(String reportId) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      await _reportsRepository.deleteReport(reportId);
      
      emit(const ReportOperationSuccess('Xóa báo cáo thành công'));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Search reports
  Future<void> searchReports(String query) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final reports = await _reportsRepository.searchReports(query);
      
      if (reports.isEmpty) {
        if (query.trim().isEmpty) {
          emit(const ReportsEmpty());
        } else {
          emit(const ReportsError('Không tìm thấy báo cáo nào'));
        }
      } else {
        emit(ReportsLoaded(reports));
      }
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Load nearby reports
  Future<void> loadNearbyReports({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final reports = await _reportsRepository.getNearbyReports(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      
      final locationLabel = 'Trong bán kính ${radiusKm.toInt()} km';
      
      if (reports.isEmpty) {
        emit(const ReportsEmpty());
      } else {
        emit(NearbyReportsLoaded(reports, locationLabel));
      }
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Mark report as resolved
  Future<void> markAsResolved(String reportId) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final updatedReport = await _reportsRepository.markAsResolved(reportId);
      
      emit(ReportOperationSuccess('Đã đánh dấu báo cáo là đã giải quyết', report: updatedReport));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Mark report as possible match
  Future<void> markAsPossibleMatch(String reportId) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      final updatedReport = await _reportsRepository.markAsPossibleMatch(reportId);
      
      emit(ReportOperationSuccess('Đã đánh dấu báo cáo có thể trùng khớp', report: updatedReport));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Report inappropriate content
  Future<void> reportContent(String reportId, String reason) async {
    if (state is ReportsLoading) return;

    emit(const ReportsLoading());

    try {
      await _reportsRepository.reportContent(reportId, reason);
      
      emit(const ReportOperationSuccess('Đã báo cáo nội dung không phù hợp'));
    } catch (error) {
      emit(ReportsError(error.toString()));
    }
  }

  /// Refresh current view
  Future<void> refresh() async {
    if (state is ReportsLoaded) {
      loadAllReports();
    } else if (state is NearbyReportsLoaded) {
      // For nearby reports, we'd need to store the coordinates
      // For now, just reload all reports
      loadAllReports();
    } else if (_currentUserId != null) {
      loadUserReports();
    } else {
      loadAllReports();
    }
  }

  /// Clear error state
  void clearError() {
    if (state is ReportsError) {
      if (_currentUserId != null) {
        loadAllReports();
      } else {
        emit(const ReportsInitial());
      }
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const ReportsInitial());
  }
}