import '../../features/pets/domain/pet_model.dart';
import '../../features/reports/domain/pet_report_model.dart';
import '../../features/community/domain/community_post_model.dart';

abstract final class AppImages {
  static const _base = 'assets/images';

  static const splashHero = '$_base/generated-1777478933278.png';
  static const onboardingLost = '$_base/generated-1777512720400.png';
  static const onboardingNearby = '$_base/generated-1777480326529.png';
  static const onboardingReunion = '$_base/generated-1777512670075.png';

  static const authWelcome = '$_base/generated-1777478933278.png';
  static const authLogin = '$_base/generated-1777481119003.png';
  static const authSignUp = '$_base/generated-1777512369581.png';
  static const authForgot = '$_base/generated-1777512379292.png';
  static const authOtp = '$_base/generated-1777481118227.png';
  static const authSuccess = '$_base/generated-1777512670075.png';

  static const homeHero = '$_base/generated-1777512631211.png';
  static const homeCommunity = '$_base/generated-1777478933278.png';

  static const petsDogHero = '$_base/generated-1777512369581.png';
  static const petsCatHero = '$_base/generated-1777512372924.png';
  static const petsProfileDog = '$_base/generated-1777480299115.png';
  static const petsProfileCat = '$_base/generated-1777481118227.png';

  static const remindersHero = '$_base/generated-1777481221328.png';
  static const remindersSupport = '$_base/generated-1777481119003.png';

  static const chatHero = '$_base/generated-1777478933278.png';
  static const chatContact = '$_base/generated-1777480204574.png';

  static const communityHero = '$_base/generated-1777512670075.png';
  static const communityFeatured = '$_base/generated-1777478933278.png';

  static const profileHero = '$_base/generated-1777478933278.png';
  static const profileAvatarDog = '$_base/generated-1777512368490.png';
  static const languageHero = '$_base/generated-1777480204574.png';

  static const reportDetail = '$_base/generated-1777480356603.png';
  static const mapNearby = '$_base/generated-1777480290799.png';
  static const lostPoster = '$_base/generated-1777480358093.png';

  static String petHeroFor(PetType type) {
    return switch (type) {
      PetType.cat => petsCatHero,
      PetType.dog || PetType.other => petsDogHero,
    };
  }

  static String petCardFor(PetType type) {
    return switch (type) {
      PetType.cat => petsProfileCat,
      PetType.dog || PetType.other => petsProfileDog,
    };
  }

  static String reportThumbFor(PetReportType type) {
    return switch (type) {
      PetReportType.lost => lostPoster,
      PetReportType.found => mapNearby,
      PetReportType.reunited => communityHero,
    };
  }

  static String communityFor(CommunityCategory category) {
    return switch (category) {
      CommunityCategory.safetyTips => chatContact,
      CommunityCategory.reunionStories => communityHero,
      CommunityCategory.lostPetAwareness => lostPoster,
      CommunityCategory.rescueSupport => splashHero,
      CommunityCategory.adoption => homeHero,
    };
  }
}
