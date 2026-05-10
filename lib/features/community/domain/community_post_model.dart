enum CommunityCategory {
  safetyTips,
  reunionStories,
  lostPetAwareness,
  rescueSupport,
  adoption,
}

class CommunityCommentModel {
  const CommunityCommentModel({
    required this.id,
    required this.authorName,
    required this.message,
    required this.timeLabel,
  });

  final String id;
  final String authorName;
  final String message;
  final String timeLabel;
}

class CommunityPostModel {
  const CommunityPostModel({
    required this.id,
    required this.authorName,
    required this.title,
    required this.body,
    required this.category,
    required this.timeLabel,
    required this.commentCount,
    required this.likeCount,
    required this.shareCount,
    required this.isFeatured,
    required this.hasImage,
    required this.comments,
  });

  final String id;
  final String authorName;
  final String title;
  final String body;
  final CommunityCategory category;
  final String timeLabel;
  final int commentCount;
  final int likeCount;
  final int shareCount;
  final bool isFeatured;
  final bool hasImage;
  final List<CommunityCommentModel> comments;
}
