import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../mock/mock_data.dart';
import '../../domain/community_post_model.dart';
import '../widgets/community_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  CommunityCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final featured = MockData.communityPosts
        .where((post) => post.isFeatured)
        .toList();
    final posts = MockData.communityPosts.where((post) {
      if (_selectedCategory == null) {
        return true;
      }
      return post.category == _selectedCategory;
    }).toList();

    return CommunityScaffold(
      floatingAction: Positioned(
        right: 24,
        bottom: 106,
        child: FloatingActionButton.extended(
          onPressed: () => context.goNamed(AppRoute.communityCreate.name),
          backgroundColor: AppColors.coral,
          elevation: 0,
          icon: const Icon(Icons.edit_rounded, color: AppColors.white),
          label: Text(
            context.l10n.communityCreatePostBtn,
            style: AppTextStyles.button.copyWith(color: AppColors.white),
          ),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              18,
              AppSpacing.screenNarrow,
              126,
            ),
            sliver: SliverList.list(
              children: [
                CommunityHeader(
                  title: context.l10n.communityTitle,
                  subtitle: context.l10n.communitySubtitle,
                  trailing: CircleGlassButton(
                    icon: Icons.edit_outlined,
                    onTap: () => context.goNamed(AppRoute.communityCreate.name),
                  ),
                ),
                const SizedBox(height: 18),
                const _CommunitySearchCard(),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FeedChip(
                        label: context.l10n.mapFilterAll,
                        selected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      for (final category in CommunityCategory.values) ...[
                        _FeedChip(
                          label: communityCategoryLabel(context, category),
                          selected: _selectedCategory == category,
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                        ),
                        if (category != CommunityCategory.values.last)
                          const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (_selectedCategory == null && featured.isNotEmpty) ...[
                  CommunityFeaturedCard(post: featured.first),
                  const SizedBox(height: 20),
                ],
                if (posts.isEmpty)
                  CommunityEmptyCard(
                    onCreatePost: () =>
                        context.goNamed(AppRoute.communityCreate.name),
                  )
                else
                  for (var index = 0; index < posts.length; index++) ...[
                    CommunityPostCard(post: posts[index]),
                    if (index != posts.length - 1) const SizedBox(height: 14),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedChip extends StatelessWidget {
  const _FeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.coral : AppColors.glassSoft,
          borderRadius: AppRadius.pillBorder,
        ),
        child: Text(
          label,
          style: AppTextStyles.chip.copyWith(
            color: selected ? AppColors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}

class _CommunitySearchCard extends StatelessWidget {
  const _CommunitySearchCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.84),
      radius: 28,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.bodyStrong,
              decoration: InputDecoration(
                hintText: context.l10n.communitySearchHint,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.72),
                ),
                filled: true,
                fillColor: AppColors.fieldWarm,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdBorder,
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.coral,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.coral,
              borderRadius: AppRadius.lgBorder,
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
