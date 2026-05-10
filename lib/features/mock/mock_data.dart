// import '../chat/domain/chat_model.dart';
import '../community/domain/community_post_model.dart';
import '../notifications/domain/notification_model.dart';
import '../pets/domain/pet_model.dart';
import '../reminders/domain/reminder_model.dart';
import '../reports/domain/pet_report_model.dart';

abstract final class MockData {
  static const profileName = 'Minh Tran';
  static const profileEmail = 'minh.petfinder@example.com';
  static const profilePhone = '+84 912 345 678';
  static const profileCity = 'Ho Chi Minh City';
  static const profileStatus =
      'Keeping Luna and Mochi ready, and helping nearby pets when alerts come in.';
  static const alertRadiusLabel = '5 km';

  static const pets = [
    PetModel(
      id: 'pet_luna',
      name: 'Luna',
      type: PetType.dog,
      breed: 'Golden Retriever',
      gender: 'female',
      ageLabel: '2 yrs',
      color: 'Honey gold',
      weightLabel: '28 kg',
      specialMarks: 'White chest patch and teal collar',
      profileStatus: 'Profile ready',
      careStatus: 'Vaccines current',
      birthLabel: 'April 2022',
      microchipNumber: '985141000123456',
      vaccinationStatus: 'Up to date',
      medicalNotes: 'Mild pollen allergy, no ongoing medication.',
      reminderLabel: 'Rabies booster tomorrow',
    ),
    PetModel(
      id: 'pet_mochi',
      name: 'Mochi',
      type: PetType.cat,
      breed: 'Domestic Shorthair',
      gender: 'male',
      ageLabel: '11 mo',
      color: 'Cream tabby',
      weightLabel: '4.8 kg',
      specialMarks: 'Small notch on left ear',
      profileStatus: 'Missing microchip',
      careStatus: 'Reminder due',
      birthLabel: 'May 2025',
      microchipNumber: 'Not added',
      vaccinationStatus: 'Booster due next week',
      medicalNotes: 'Very nervous outdoors, prefers quiet handling.',
      reminderLabel: 'Grooming in 3 days',
    ),
  ];

  static const reports = [
    PetReportModel(
      id: 'report_luna_lost',
      type: PetReportType.lost,
      status: PetReportStatus.active,
      petName: 'Luna',
      breed: 'Golden Retriever',
      locationLabel: 'Maple Street Park',
      timeLabel: '25 min ago',
      distanceLabel: '1.2 km',
      description: 'Last seen near the playground wearing a teal collar.',
    ),
    PetReportModel(
      id: 'report_milo_found',
      type: PetReportType.found,
      status: PetReportStatus.active,
      petName: 'Unknown cat',
      breed: 'Orange tabby',
      locationLabel: 'Riverside Cafe',
      timeLabel: '1 hr ago',
      distanceLabel: '2.8 km',
      description: 'Friendly cat staying under the patio table.',
    ),
  ];

  static const myReports = [
    PetReportModel(
      id: 'my_report_luna_active',
      type: PetReportType.lost,
      status: PetReportStatus.active,
      petName: 'Luna',
      breed: 'Golden Retriever',
      locationLabel: 'Maple Street Park',
      timeLabel: '25 min ago',
      distanceLabel: '1.2 km',
      description: 'Last seen near the playground wearing a teal collar.',
    ),
    PetReportModel(
      id: 'my_report_bim_reunited',
      type: PetReportType.reunited,
      status: PetReportStatus.resolved,
      petName: 'Bim',
      breed: 'Mixed breed dog',
      locationLabel: 'Canal Path',
      timeLabel: '2 days ago',
      distanceLabel: '0.8 km',
      description: 'Thanks to nearby volunteers, Bim was safely reunited.',
    ),
    PetReportModel(
      id: 'my_report_miso_closed',
      type: PetReportType.found,
      status: PetReportStatus.closed,
      petName: 'Miso',
      breed: 'Calico cat',
      locationLabel: 'Rose Alley',
      timeLabel: 'Last week',
      distanceLabel: '3.1 km',
      description:
          'Original finder could no longer hold the pet and closed the report.',
    ),
  ];

  static const savedReportIds = <String>[
    'report_luna_lost',
    'report_milo_found',
  ];

  static const reminders = [
    ReminderModel(
      id: 'reminder_vaccine',
      petId: 'pet_luna',
      title: 'Rabies vaccine',
      category: ReminderCategory.vaccination,
      bucket: ReminderBucket.tomorrow,
      dateLabel: 'Tomorrow, May 1',
      timeLabel: '9:00 AM',
      repeatLabel: 'Yearly',
      notes: 'Bring Luna\'s vaccine booklet and keep her breakfast light.',
      notificationsEnabled: true,
      status: ReminderStatus.upcoming,
    ),
    ReminderModel(
      id: 'reminder_grooming',
      petId: 'pet_mochi',
      title: 'Coat brushing session',
      category: ReminderCategory.grooming,
      bucket: ReminderBucket.today,
      dateLabel: 'Today, April 30',
      timeLabel: '6:30 PM',
      repeatLabel: 'Every 2 weeks',
      notes: 'Use the softer brush and keep the room quiet.',
      notificationsEnabled: true,
      status: ReminderStatus.dueSoon,
    ),
    ReminderModel(
      id: 'reminder_deworming',
      petId: 'pet_luna',
      title: 'Deworming chew',
      category: ReminderCategory.deworming,
      bucket: ReminderBucket.thisWeek,
      dateLabel: 'Saturday, May 3',
      timeLabel: '8:00 AM',
      repeatLabel: 'Every 3 months',
      notes: 'Offer after breakfast and monitor for 30 minutes.',
      notificationsEnabled: true,
      status: ReminderStatus.upcoming,
    ),
    ReminderModel(
      id: 'reminder_vet',
      petId: 'pet_mochi',
      title: 'Annual wellness check',
      category: ReminderCategory.vetVisit,
      bucket: ReminderBucket.later,
      dateLabel: 'May 18',
      timeLabel: '10:15 AM',
      repeatLabel: 'Yearly',
      notes: 'Bring previous lab summary and discuss booster schedule.',
      notificationsEnabled: false,
      status: ReminderStatus.upcoming,
    ),
    ReminderModel(
      id: 'reminder_medication',
      petId: 'pet_luna',
      title: 'Allergy tablet',
      category: ReminderCategory.medication,
      bucket: ReminderBucket.today,
      dateLabel: 'Today, April 30',
      timeLabel: '8:00 PM',
      repeatLabel: 'Daily for 7 days',
      notes: 'Give with food to avoid an upset stomach.',
      notificationsEnabled: true,
      status: ReminderStatus.completed,
    ),
  ];

  static const notifications = [
    NotificationModel(
      id: 'notification_nearby',
      title: 'Lost pet nearby',
      message: 'Luna was reported missing 1.2 km from you.',
      timeLabel: 'Now',
      isRead: false,
      reportId: 'report_luna_lost',
      chatId: 'chat_luna',
    ),
    NotificationModel(
      id: 'notification_found',
      title: 'Found report updated',
      message: 'A nearby orange tabby report now has clearer photos.',
      timeLabel: '18 min ago',
      isRead: true,
      reportId: 'report_milo_found',
    ),
    NotificationModel(
      id: 'notification_reminder',
      title: 'Reminder due today',
      message: 'Luna\'s grooming session is set for this evening.',
      timeLabel: '2 hr ago',
      isRead: false,
      reminderId: 'reminder_grooming',
    ),
  ];

  static List<PetReportModel> get allReports => [...reports, ...myReports];

  static PetReportModel? tryResolveReport(String reportId) {
    for (final report in allReports) {
      if (report.id == reportId) {
        return report;
      }
    }
    return null;
  }

  static PetReportModel resolveReport(String reportId) {
    return tryResolveReport(reportId) ?? allReports.first;
  }

  static PetModel? tryResolvePet(String petId) {
    for (final pet in pets) {
      if (pet.id == petId) {
        return pet;
      }
    }
    return null;
  }

  static ReminderModel? tryResolveReminder(String reminderId) {
    for (final reminder in reminders) {
      if (reminder.id == reminderId) {
        return reminder;
      }
    }
    return null;
  }

  // Chat methods commented out due to model changes
  // static ChatModel? tryResolveChat(String chatId) {
  //   return null;
  // }

  // static ChatModel? resolveChatForReport(String reportId) {
  //   return null;
  // }

  static CommunityPostModel? tryResolveCommunityPost(String postId) {
    for (final post in communityPosts) {
      if (post.id == postId) {
        return post;
      }
    }
    return null;
  }

  static const communityPosts = [
    CommunityPostModel(
      id: 'post_1',
      authorName: 'Mai Nguyen',
      title: 'How to approach a scared dog safely',
      body:
          'A small dog has been hiding near our building since this morning. Keep your body turned slightly sideways, speak softly, and let the dog decide whether to move closer. Place water and food a short distance away instead of reaching directly toward them.',
      category: CommunityCategory.safetyTips,
      timeLabel: '12 min ago',
      commentCount: 8,
      likeCount: 41,
      shareCount: 6,
      isFeatured: false,
      hasImage: true,
      comments: [
        CommunityCommentModel(
          id: 'comment_1',
          authorName: 'An Tran',
          message:
              'Turning sideways and kneeling a little lower helped me with a nervous beagle last month.',
          timeLabel: '7 min ago',
        ),
        CommunityCommentModel(
          id: 'comment_2',
          authorName: 'Thu Le',
          message:
              'Food plus a calm voice worked for us too. Gloves are a good idea if the dog is injured.',
          timeLabel: '2 min ago',
        ),
      ],
    ),
    CommunityPostModel(
      id: 'post_2',
      authorName: 'Linh Pham',
      title: 'Reunited after a rainy night search',
      body:
          'After sharing flyers, asking nearby shop owners, and checking the canal path at first light, Bim finally came home. The strongest help came from people who reshared the alert within the first hour.',
      category: CommunityCategory.reunionStories,
      timeLabel: '1 hr ago',
      commentCount: 14,
      likeCount: 86,
      shareCount: 9,
      isFeatured: true,
      hasImage: true,
      comments: [
        CommunityCommentModel(
          id: 'comment_3',
          authorName: 'Mai Nguyen',
          message:
              'This is the kind of update everyone needs to see. So glad Bim is home.',
          timeLabel: '48 min ago',
        ),
      ],
    ),
    CommunityPostModel(
      id: 'post_3',
      authorName: 'Rescue Corner',
      title: 'Weekend foster slots still needed',
      body:
          'Three kittens and one older dog still need short foster support this weekend. Even one or two quiet nights indoors can make a big difference before veterinary intake.',
      category: CommunityCategory.rescueSupport,
      timeLabel: '3 hr ago',
      commentCount: 5,
      likeCount: 29,
      shareCount: 12,
      isFeatured: false,
      hasImage: false,
      comments: [
        CommunityCommentModel(
          id: 'comment_4',
          authorName: 'Minh Tran',
          message:
              'I can help with food delivery if a foster home is arranged.',
          timeLabel: '1 hr ago',
        ),
      ],
    ),
  ];

  // Chat mock data commented out due to model changes
  // static const chats = [];

  static const lostPetReports = <PetReportModel>[];
}
