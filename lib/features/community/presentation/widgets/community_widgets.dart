import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/assets/app_images.dart';
import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/community_post_model.dart';

class CommunityScaffold extends StatelessWidget {
  const CommunityScaffold({
    required this.child,
    super.key,
    this.bottomNav = true,
    this.floatingAction,
  });

  final Widget child;
  final bool bottomNav;
  final Widget? floatingAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _CommunityBackdrop(),
              child,
              if (floatingAction case final Widget action) action,
              if (bottomNav)
                const Positioned(
                  left: 18,
                  right: 18,
                  bottom: 22,
                  child: CommunityBottomNavigation(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommunityBottomNavigation extends StatelessWidget {
  const CommunityBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      AppBottomNavItem(
        icon: Icons.home_rounded,
        label: context.l10n.commonHome,
      ),
      AppBottomNavItem(
        icon: Icons.groups_2_outlined,
        label: context.l10n.commonCommunity,
      ),
      AppBottomNavItem(icon: Icons.pets, label: context.l10n.commonPets),
      AppBottomNavItem(
        icon: Icons.person_outline,
        label: context.l10n.commonProfile,
      ),
    ];
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBottomNav(
          currentIndex: 1,
          onChanged: (index) {
            if (index == 0) {
              context.goNamed(AppRoute.home.name);
            } else if (index == 1) {
              context.goNamed(AppRoute.communityFeed.name);
            } else if (index == 2) {
              context.goNamed(AppRoute.petsList.name);
            } else if (index == 3) {
              context.goNamed(AppRoute.profileOverview.name);
            }
          },
          items: items,
        ),
        Positioned(
          top: -18,
          child: InkWell(
            borderRadius: AppRadius.pillBorder,
            onTap: () => context.goNamed(AppRoute.communityCreate.name),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryButton,
                border: Border.all(color: AppColors.white, width: 4),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommunityHeader extends StatelessWidget {
  const CommunityHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 14)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 13)),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class CircleGlassButton extends StatelessWidget {
  const CircleGlassButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.pillBorder,
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: AppRadius.cardBorder,
          boxShadow: AppShadows.floating,
        ),
        child: Icon(icon, color: AppColors.charcoal, size: 20),
      ),
    );
  }
}

class CommunityFeaturedCard extends StatelessWidget {
  const CommunityFeaturedCard({required this.post, super.key});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32),
      onTap: () => context.goNamed(
        AppRoute.communityDetail.name,
        pathParameters: {'postId': post.id},
      ),
      child: AppCard(
        color: AppColors.glass,
        radius: 32,
        shadow: AppShadows.raisedCard,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CommunityHeroArt(
              category: post.category,
              height: 186,
              featured: true,
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AppChip(
                    label: communityCategoryLabel(context, post.category),
                    color: AppColors.fieldWarm,
                  ),
                  const SizedBox(width: 8),
                  AppChip(
                    label: context.l10n.communityWidgetFeatured,
                    icon: Icons.auto_awesome,
                    color: AppColors.fieldCool,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: AppTextStyles.heroTitle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            _CommunityMetaRow(post: post),
          ],
        ),
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({required this.post, super.key});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => context.goNamed(
        AppRoute.communityDetail.name,
        pathParameters: {'postId': post.id},
      ),
      child: AppCard(
        color: AppColors.white.withValues(alpha: 0.84),
        radius: 28,
        shadow: AppShadows.softCard,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.hasImage) ...[
              _CommunityHeroArt(category: post.category, height: 158),
              const SizedBox(height: 14),
            ],
            Row(
              children: [
                AppChip(
                  label: communityCategoryLabel(context, post.category),
                  color: AppColors.fieldCool,
                ),
                const Spacer(),
                Icon(
                  Icons.share_outlined,
                  color: AppColors.muted.withValues(alpha: 0.8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.title, style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 14),
            _CommunityMetaRow(post: post),
          ],
        ),
      ),
    );
  }
}

class CommunityCommentCard extends StatelessWidget {
  const CommunityCommentCard({required this.comment, super.key});

  final CommunityCommentModel comment;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.82),
      radius: 24,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CommunityAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.authorName,
                        style: AppTextStyles.bodyStrong,
                      ),
                    ),
                    Text(
                      comment.timeLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.message,
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityEmptyCard extends StatelessWidget {
  const CommunityEmptyCard({required this.onCreatePost, super.key});

  final VoidCallback onCreatePost;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 34,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: const AppAssetImage(
              assetPath: AppImages.communityHero,
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
          ),
          const SizedBox(height: 18),
          EmptyState(
            title: context.l10n.communityWidgetEmpty,
            message: context.l10n.communityWidgetFirstShare,
            icon: Icons.favorite_border,
            actionLabel: context.l10n.communityCreatePostBtn,
            onActionPressed: onCreatePost,
          ),
        ],
      ),
    );
  }
}

class CommunityComposerCard extends StatelessWidget {
  const CommunityComposerCard({
    required this.titleController,
    required this.bodyController,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController bodyController;
  final CommunityCategory selectedCategory;
  final ValueChanged<CommunityCategory> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 30,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.communityWidgetTellHint,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.communityWidgetTips,
            style: AppTextStyles.body.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 16),
          _Label('Category'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in CommunityCategory.values)
                AppChip(
                  label: communityCategoryLabel(context, category),
                  selected: category == selectedCategory,
                  onTap: () => onCategorySelected(category),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _LabeledInput(
            label: context.l10n.communityWidgetTitleLabel,
            hint: 'Ex: What helped us bring Bim home safely',
            controller: titleController,
          ),
          const SizedBox(height: 14),
          _LabeledInput(
            label: context.l10n.communityWidgetContentLabel,
            hint: 'Share the full story, tip, or update',
            controller: bodyController,
            maxLines: 7,
          ),
          const SizedBox(height: 14),
          _ImagePlaceholderCard(category: selectedCategory),
          const SizedBox(height: 14),
          _Label('Visibility'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppChip(
                  label: context.l10n.communityWidgetLocal,
                  icon: Icons.place_outlined,
                  selected: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppChip(
                  label: context.l10n.communityWidgetWiderArea,
                  icon: Icons.public,
                  color: AppColors.fieldCool,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommunityReactionRow extends StatelessWidget {
  const CommunityReactionRow({required this.post, super.key});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ReactionButton(
          icon: Icons.favorite_border,
          label: '${post.likeCount}',
          color: AppColors.coral,
        ),
        const SizedBox(width: 10),
        _ReactionButton(
          icon: Icons.mode_comment_outlined,
          label: '${post.commentCount}',
          color: AppColors.teal,
        ),
        const SizedBox(width: 10),
        _ReactionButton(
          icon: Icons.share_outlined,
          label: '${post.shareCount}',
          color: AppColors.charcoal,
        ),
      ],
    );
  }
}

String communityCategoryLabel(
  BuildContext context,
  CommunityCategory category,
) {
  return switch (category) {
    CommunityCategory.safetyTips => context.l10n.communityCategorySafetyTips,
    CommunityCategory.reunionStories =>
      context.l10n.communityCategoryReunionStories,
    CommunityCategory.lostPetAwareness =>
      context.l10n.communityCategoryLostPetAwareness,
    CommunityCategory.rescueSupport =>
      context.l10n.communityCategoryRescueSupport,
    CommunityCategory.adoption => context.l10n.communityCategoryAdoption,
  };
}

class _CommunityHeroArt extends StatelessWidget {
  const _CommunityHeroArt({
    required this.category,
    required this.height,
    this.featured = false,
  });

  final CommunityCategory category;
  final double height;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(featured ? 28 : 24),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AppAssetImage(
              assetPath: AppImages.communityFor(category),
              borderRadius: BorderRadius.circular(featured ? 28 : 24),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(featured ? 28 : 24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.charcoal.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityMetaRow extends StatelessWidget {
  const _CommunityMetaRow({required this.post});

  final CommunityPostModel post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _CommunityAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.authorName, style: AppTextStyles.bodyStrong),
              const SizedBox(height: 2),
              Text(
                post.timeLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
        CommunityReactionRow(post: post),
      ],
    );
  }
}

class _CommunityAvatar extends StatelessWidget {
  const _CommunityAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const AppAssetImage(
        assetPath: AppImages.profileAvatarDog,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.pillBorder,
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.chip.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(color: AppColors.charcoal),
    );
  }
}

class _LabeledInput extends StatelessWidget {
  const _LabeledInput({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyStrong,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.muted.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: AppColors.fieldWarm,
            border: OutlineInputBorder(
              borderRadius: AppRadius.mdBorder,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePlaceholderCard extends StatelessWidget {
  const _ImagePlaceholderCard({required this.category});

  final CommunityCategory category;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.8),
      radius: 24,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Label('Add image'),
          const SizedBox(height: 10),
          _CommunityHeroArt(category: category, height: 144),
          const SizedBox(height: 10),
          Text(
            context.l10n.communityWidgetPhotoHint,
            style: AppTextStyles.caption.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _CommunityBackdrop extends StatelessWidget {
  const _CommunityBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -18,
          top: 86,
          child: _Glow(
            width: 184,
            height: 184,
            color: AppColors.teal.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          left: -38,
          top: 230,
          child: _Glow(
            width: 220,
            height: 220,
            color: AppColors.coral.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          right: 40,
          top: 200,
          child: Icon(
            Icons.pets,
            size: 26,
            color: AppColors.white.withValues(alpha: 0.42),
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
