class ProfileOverviewStats {
  const ProfileOverviewStats({
    required this.activeReportsCount,
    required this.petsCount,
    required this.communityPostsCount,
    required this.helpedCasesCount,
  });

  const ProfileOverviewStats.empty()
    : activeReportsCount = 0,
      petsCount = 0,
      communityPostsCount = 0,
      helpedCasesCount = 0;

  final int activeReportsCount;
  final int petsCount;
  final int communityPostsCount;
  final int helpedCasesCount;
}
