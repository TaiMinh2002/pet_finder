enum PetReportType { lost, found, reunited }

enum PetReportStatus { active, possibleMatch, resolved, closed, reported }

extension PetReportTypeExtension on PetReportType {
  String get displayName {
    switch (this) {
      case PetReportType.lost:
        return 'Mất tích';
      case PetReportType.found:
        return 'Tìm thấy';
      case PetReportType.reunited:
        return 'Đã đoàn tụ';
    }
  }
}

extension PetReportStatusExtension on PetReportStatus {
  String get displayName {
    switch (this) {
      case PetReportStatus.active:
        return 'Đang tìm';
      case PetReportStatus.possibleMatch:
        return 'Có thể trùng khớp';
      case PetReportStatus.resolved:
        return 'Đã giải quyết';
      case PetReportStatus.closed:
        return 'Đã đóng';
      case PetReportStatus.reported:
        return 'Đã báo cáo';
    }
  }
}

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
    this.ownerId,
    this.contactInfo,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
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
  final String? ownerId;
  final String? contactInfo;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PetReportModel copyWith({
    String? id,
    PetReportType? type,
    PetReportStatus? status,
    String? petName,
    String? breed,
    String? locationLabel,
    String? timeLabel,
    String? description,
    String? distanceLabel,
    String? photoUrl,
    String? ownerId,
    String? contactInfo,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PetReportModel(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      petName: petName ?? this.petName,
      breed: breed ?? this.breed,
      locationLabel: locationLabel ?? this.locationLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      description: description ?? this.description,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      photoUrl: photoUrl ?? this.photoUrl,
      ownerId: ownerId ?? this.ownerId,
      contactInfo: contactInfo ?? this.contactInfo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetReportModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          status == other.status &&
          petName == other.petName &&
          breed == other.breed &&
          locationLabel == other.locationLabel &&
          timeLabel == other.timeLabel &&
          description == other.description &&
          distanceLabel == other.distanceLabel &&
          photoUrl == other.photoUrl &&
          ownerId == other.ownerId &&
          contactInfo == other.contactInfo &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      status.hashCode ^
      petName.hashCode ^
      breed.hashCode ^
      locationLabel.hashCode ^
      timeLabel.hashCode ^
      description.hashCode ^
      distanceLabel.hashCode ^
      photoUrl.hashCode ^
      ownerId.hashCode ^
      contactInfo.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() {
    return 'PetReportModel(id: $id, type: $type, status: $status, petName: $petName, breed: $breed, locationLabel: $locationLabel, timeLabel: $timeLabel, description: $description, distanceLabel: $distanceLabel, photoUrl: $photoUrl, ownerId: $ownerId, contactInfo: $contactInfo, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
