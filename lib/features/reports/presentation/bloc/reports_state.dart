import '../../../../core/bloc/bloc_exports.dart';
import '../../domain/pet_report_model.dart';

/// Reports states
abstract class ReportsState extends BaseState {
  const ReportsState();
}

/// Initial reports state
class ReportsInitial extends ReportsState {
  const ReportsInitial();

  @override
  bool operator ==(Object other) => other is ReportsInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Loading reports
class ReportsLoading extends ReportsState {
  const ReportsLoading();

  @override
  bool operator ==(Object other) => other is ReportsLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Reports loaded successfully
class ReportsLoaded extends ReportsState {
  const ReportsLoaded(this.reports);

  final List<PetReportModel> reports;

  @override
  bool operator ==(Object other) =>
      other is ReportsLoaded &&
      other.reports.length == reports.length &&
      other.reports.every((report) => reports.contains(report));

  @override
  int get hashCode => reports.hashCode;
}

/// Single report loaded
class ReportLoaded extends ReportsState {
  const ReportLoaded(this.report);

  final PetReportModel report;

  @override
  bool operator ==(Object other) =>
      other is ReportLoaded && other.report == report;

  @override
  int get hashCode => report.hashCode;
}

/// Report operation success (create/update/delete)
class ReportOperationSuccess extends ReportsState {
  const ReportOperationSuccess(this.message, {this.report});

  final String message;
  final PetReportModel? report;

  @override
  bool operator ==(Object other) =>
      other is ReportOperationSuccess &&
      other.message == message &&
      other.report == report;

  @override
  int get hashCode => Object.hash(message, report);
}

/// Reports error state
class ReportsError extends ReportsState {
  const ReportsError(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      other is ReportsError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

/// Empty reports state
class ReportsEmpty extends ReportsState {
  const ReportsEmpty();

  @override
  bool operator ==(Object other) => other is ReportsEmpty;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Nearby reports loaded
class NearbyReportsLoaded extends ReportsState {
  const NearbyReportsLoaded(this.reports, this.location);

  final List<PetReportModel> reports;
  final String location;

  @override
  bool operator ==(Object other) =>
      other is NearbyReportsLoaded &&
      other.reports.length == reports.length &&
      other.reports.every((report) => reports.contains(report)) &&
      other.location == location;

  @override
  int get hashCode => Object.hash(reports, location);
}
