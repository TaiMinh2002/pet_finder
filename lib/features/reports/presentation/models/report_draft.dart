import '../../domain/pet_report_model.dart';

class ReportDraft {
  const ReportDraft({
    this.type = PetReportType.lost,
    this.petName = 'Luna',
    this.petType = 'dog',
    this.breed = 'Golden Retriever',
    this.gender = 'female',
    this.color = 'Honey gold',
    this.specialMarks = 'White chest patch and teal collar',
    this.address = 'Maple Street Park, District 2',
    this.dateLabel = 'today',
    this.timeLabel = '6:20 PM',
    this.phone = '+84 901 234 567',
    this.altContact = '@petfinder.minh',
    this.isPhoneVisible = true,
    this.photoLabels = const ['face', 'full_body'],
  });

  final PetReportType type;
  final String petName;
  final String petType;
  final String breed;
  final String gender;
  final String color;
  final String specialMarks;
  final String address;
  final String dateLabel;
  final String timeLabel;
  final String phone;
  final String altContact;
  final bool isPhoneVisible;
  final List<String> photoLabels;

  ReportDraft copyWith({
    PetReportType? type,
    String? petName,
    String? petType,
    String? breed,
    String? gender,
    String? color,
    String? specialMarks,
    String? address,
    String? dateLabel,
    String? timeLabel,
    String? phone,
    String? altContact,
    bool? isPhoneVisible,
    List<String>? photoLabels,
  }) {
    return ReportDraft(
      type: type ?? this.type,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      color: color ?? this.color,
      specialMarks: specialMarks ?? this.specialMarks,
      address: address ?? this.address,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      phone: phone ?? this.phone,
      altContact: altContact ?? this.altContact,
      isPhoneVisible: isPhoneVisible ?? this.isPhoneVisible,
      photoLabels: photoLabels ?? this.photoLabels,
    );
  }
}
