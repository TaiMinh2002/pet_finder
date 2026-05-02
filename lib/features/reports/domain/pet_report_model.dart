enum PetReportType { lost, found, reunited }

enum PetReportStatus { active, possibleMatch, resolved, closed, reported }

class PetReportModel {
  const PetReportModel({
    required this.id,
    required this.type,
    required this.status,
    required this.petName,
    required this.breed,
    required this.locationLabel,
    required this.timeLabel,
    required this.description,
    required this.distanceLabel,
    this.photoUrl,
  });

  final String id;
  final PetReportType type;
  final PetReportStatus status;
  final String petName;
  final String breed;
  final String locationLabel;
  final String timeLabel;
  final String description;
  final String distanceLabel;
  final String? photoUrl;
}
