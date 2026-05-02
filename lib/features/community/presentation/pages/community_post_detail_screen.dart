import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../mock/mock_data.dart';
import '../widgets/community_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class CommunityPostDetailScreen extends StatelessWidget {
  const CommunityPostDetailScreen({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final post = MockData.tryResolveCommunityPost(postId);
    if (post == null) {
      return CommunityScaffold(
        bottomNav: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenNarrow,
            18,
            AppSpacing.screenNarrow,
            40,
          ),
          child: AppErrorState(
            title: context.l10n.communityPostNotFoundTitle,
            message: context.l10n.communityPostNotFoundDesc,
            retryLabel: context.l10n.communityBackToFeed,
            onRetry: () => context.goNamed(AppRoute.communityFeed.name),
          ),
        ),
      );
    }
    final relatedPosts = MockData.communityPosts
        .where((item) => item.id != post.id && item.category == post.category)
        .toList();

    return CommunityScaffold(
      bottomNav: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              18,
              AppSpacing.screenNarrow,
              40,
            ),
            sliver: SliverList.list(
              children: [
                CommunityHeader(
                  title: context.l10n.communityStoryTitle,
                  subtitle: context.l10n.communityStoryDesc,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.safeBackNamed(AppRoute.communityFeed),
                  ),
                  trailing: CircleGlassButton(
                    icon: Icons.share_outlined,
                    onTap: () => context.goNamed(AppRoute.communityFeed.name),
                  ),
                ),
                const SizedBox(height: 18),
                CommunityFeaturedCard(post: post),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: AppTextStyles.heroTitle.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 10),
                Text(post.body, style: AppTextStyles.body),
                const SizedBox(height: 16),
                CommunityReactionRow(post: post),
                const SizedBox(height: 22),
                SectionHeader(title: context.l10n.communityComments),
                const SizedBox(height: 12),
                for (var index = 0; index < post.comments.length; index++) ...[
                  CommunityCommentCard(comment: post.comments[index]),
                  if (index != post.comments.length - 1)
                    const SizedBox(height: 10),
                ],
                const SizedBox(height: 20),
                if (relatedPosts.isNotEmpty) ...[
                  SectionHeader(title: context.l10n.communityRelatedPosts),
                  const SizedBox(height: 12),
                  for (var index = 0; index < relatedPosts.length; index++) ...[
                    CommunityPostCard(post: relatedPosts[index]),
                    if (index != relatedPosts.length - 1)
                      const SizedBox(height: 12),
                  ],
                ],
                const SizedBox(height: 18),
                AppButton(
                  label: context.l10n.communityCreateOwnBtn,
                  icon: Icons.edit_outlined,
                  onPressed: () =>
                      context.goNamed(AppRoute.communityCreate.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
