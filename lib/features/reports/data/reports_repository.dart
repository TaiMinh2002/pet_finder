import '../domain/pet_report_model.dart';
import '../../mock/mock_data.dart';

/// Mock reports repository
class ReportsRepository {
  static ReportsRepository? _instance;
  static ReportsRepository get instance => _instance ??= ReportsRepository._();
  ReportsRepository._();

  final List<PetReportModel> _reports = [];

  /// Initialize with mock data
  void _initializeMockData() {
    if (_reports.isEmpty) {
      _reports.addAll(
        MockData.lostPetReports.map(
          (report) => report.copyWith(
            ownerId: 'current_user_id', // Mock some reports as current user's
            createdAt: DateTime.now().subtract(
              Duration(hours: DateTime.now().millisecondsSinceEpoch % 72),
            ),
            updatedAt: DateTime.now(),
          ),
        ),
      );

      // Add some reports from other users
      _reports.addAll(
        MockData.lostPetReports.map(
          (report) => report.copyWith(
            id: 'other_${report.id}',
            ownerId: 'other_user_id',
            createdAt: DateTime.now().subtract(
              Duration(hours: DateTime.now().millisecondsSinceEpoch % 120),
            ),
            updatedAt: DateTime.now(),
          ),
        ),
      );
    }
  }

  /// Get all reports (public feed)
  Future<List<PetReportModel>> getAllReports({
    PetReportType? filterType,
    PetReportStatus? filterStatus,
  }) async {
    _initializeMockData();

    await Future.delayed(const Duration(seconds: 1));

    var filteredReports = List<PetReportModel>.from(_reports);

    if (filterType != null) {
      filteredReports = filteredReports
          .where((r) => r.type == filterType)
          .toList();
    }

    if (filterStatus != null) {
      filteredReports = filteredReports
          .where((r) => r.status == filterStatus)
          .toList();
    }

    // Sort by creation date (newest first)
    filteredReports.sort(
      (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
        a.createdAt ?? DateTime.now(),
      ),
    );

    return filteredReports;
  }

  /// Get user's own reports
  Future<List<PetReportModel>> getUserReports(String userId) async {
    _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 800));

    final userReports = _reports.where((r) => r.ownerId == userId).toList();

    // Sort by creation date (newest first)
    userReports.sort(
      (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
        a.createdAt ?? DateTime.now(),
      ),
    );

    return userReports;
  }

  /// Get report by ID
  Future<PetReportModel?> getReportById(String reportId) async {
    _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      return _reports.firstWhere((report) => report.id == reportId);
    } catch (e) {
      return null;
    }
  }

  /// Create new report
  Future<PetReportModel> createReport({
    required PetReportType type,
    required String petName,
    required String breed,
    required String locationLabel,
    required String description,
    required String contactInfo,
    String? photoUrl,
    double? latitude,
    double? longitude,
    String? ownerId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    // Validation
    if (petName.trim().isEmpty) {
      throw Exception('Tên thú cưng không được để trống');
    }

    if (breed.trim().isEmpty) {
      throw Exception('Giống thú cưng không được để trống');
    }

    if (locationLabel.trim().isEmpty) {
      throw Exception('Địa điểm không được để trống');
    }

    if (description.trim().isEmpty) {
      throw Exception('Mô tả không được để trống');
    }

    if (contactInfo.trim().isEmpty) {
      throw Exception('Thông tin liên hệ không được để trống');
    }

    final now = DateTime.now();
    final newReport = PetReportModel(
      id: 'report_${now.millisecondsSinceEpoch}',
      type: type,
      status: PetReportStatus.active,
      petName: petName.trim(),
      breed: breed.trim(),
      locationLabel: locationLabel.trim(),
      timeLabel: _formatTimeLabel(now),
      description: description.trim(),
      distanceLabel: '0 km',
      photoUrl: photoUrl,
      ownerId: ownerId ?? 'current_user_id',
      contactInfo: contactInfo.trim(),
      latitude: latitude,
      longitude: longitude,
      createdAt: now,
      updatedAt: now,
    );

    _reports.insert(0, newReport); // Add to beginning
    return newReport;
  }

  /// Update existing report
  Future<PetReportModel> updateReport(
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
    await Future.delayed(const Duration(seconds: 1));

    final index = _reports.indexWhere((report) => report.id == reportId);
    if (index == -1) {
      throw Exception('Không tìm thấy báo cáo');
    }

    final currentReport = _reports[index];
    final updatedReport = currentReport.copyWith(
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
      updatedAt: DateTime.now(),
    );

    _reports[index] = updatedReport;
    return updatedReport;
  }

  /// Delete report
  Future<void> deleteReport(String reportId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final index = _reports.indexWhere((report) => report.id == reportId);
    if (index == -1) {
      throw Exception('Không tìm thấy báo cáo');
    }

    _reports.removeAt(index);
  }

  /// Search reports
  Future<List<PetReportModel>> searchReports(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (query.trim().isEmpty) {
      return getAllReports();
    }

    _initializeMockData();
    final searchQuery = query.toLowerCase();

    final searchResults = _reports
        .where(
          (report) =>
              report.petName.toLowerCase().contains(searchQuery) ||
              report.breed.toLowerCase().contains(searchQuery) ||
              report.locationLabel.toLowerCase().contains(searchQuery) ||
              report.description.toLowerCase().contains(searchQuery),
        )
        .toList();

    // Sort by relevance (exact matches first, then partial matches)
    searchResults.sort((a, b) {
      final aExactMatch =
          a.petName.toLowerCase() == searchQuery ||
          a.breed.toLowerCase() == searchQuery;
      final bExactMatch =
          b.petName.toLowerCase() == searchQuery ||
          b.breed.toLowerCase() == searchQuery;

      if (aExactMatch && !bExactMatch) return -1;
      if (!aExactMatch && bExactMatch) return 1;

      // If both or neither are exact matches, sort by date
      return (b.createdAt ?? DateTime.now()).compareTo(
        a.createdAt ?? DateTime.now(),
      );
    });

    return searchResults;
  }

  /// Get nearby reports (mock implementation)
  Future<List<PetReportModel>> getNearbyReports({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    _initializeMockData();

    // For mock, return all reports and simulate distance
    final nearbyReports = _reports
        .map((report) {
          // Mock distance calculation
          final mockDistance = (DateTime.now().millisecondsSinceEpoch % 20)
              .toDouble();
          return report.copyWith(
            distanceLabel: '${mockDistance.toStringAsFixed(1)} km',
          );
        })
        .where((report) {
          // Filter by mock radius
          final distance =
              double.tryParse(report.distanceLabel.replaceAll(' km', '')) ?? 0;
          return distance <= radiusKm;
        })
        .toList();

    // Sort by distance
    nearbyReports.sort((a, b) {
      final distA = double.tryParse(a.distanceLabel.replaceAll(' km', '')) ?? 0;
      final distB = double.tryParse(b.distanceLabel.replaceAll(' km', '')) ?? 0;
      return distA.compareTo(distB);
    });

    return nearbyReports;
  }

  /// Mark report as resolved
  Future<PetReportModel> markAsResolved(String reportId) async {
    return updateReport(reportId, status: PetReportStatus.resolved);
  }

  /// Mark report as possible match
  Future<PetReportModel> markAsPossibleMatch(String reportId) async {
    return updateReport(reportId, status: PetReportStatus.possibleMatch);
  }

  /// Report inappropriate content
  Future<void> reportContent(String reportId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In real implementation, this would flag the report for moderation
    // For mock, we just update the status
    updateReport(reportId, status: PetReportStatus.reported);
  }

  /// Helper method to format time label
  String _formatTimeLabel(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else {
      return '${difference.inDays} ngày trước';
    }
  }
}
