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
import '../../../mock/mock_data.dart';
import '../../../reports/domain/pet_report_model.dart';

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({
    required this.child,
    super.key,
    this.bottomNav = true,
  });

  final Widget child;
  final bool bottomNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.warmTeal),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              const _ProfileBackdrop(),
              child,
              if (bottomNav)
                const Positioned(
                  left: 18,
                  right: 18,
                  bottom: 22,
                  child: ProfileBottomNavigation(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBottomNavigation extends StatelessWidget {
  const ProfileBottomNavigation({super.key});

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
          currentIndex: 3,
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
            onTap: () => context.goNamed(AppRoute.profileEdit.name),
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
                Icons.edit_outlined,
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

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
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

class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const _ProfileAvatar(size: 92),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MockData.profileName,
                  style: AppTextStyles.heroTitle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  MockData.profileEmail,
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  MockData.profileStatus,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
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

class ProfileStatGrid extends StatelessWidget {
  const ProfileStatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = <({String label, String value, Color color, IconData icon})>[
      (
        label: context.l10n.commonMyReports,
        value:
            '${MockData.myReports.where((r) => r.status == PetReportStatus.active).length}',
        color: AppColors.coral,
        icon: Icons.campaign_outlined,
      ),
      (
        label: context.l10n.commonPets,
        value: '${MockData.pets.length}',
        color: AppColors.teal,
        icon: Icons.pets,
      ),
      (
        label: context.l10n.commonCommunity,
        value: '${MockData.communityPosts.length}',
        color: AppColors.green,
        icon: Icons.groups_2_outlined,
      ),
      (
        label: context.l10n.profileHelpedCases,
        value: '${MockData.chats.length + 2}',
        color: AppColors.coralDark,
        icon: Icons.favorite_outline,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.48,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return AppCard(
          color: AppColors.white.withValues(alpha: 0.82),
          radius: 24,
          shadow: AppShadows.softCard,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.14),
                  borderRadius: AppRadius.mdBorder,
                ),
                child: Icon(stat.icon, color: stat.color),
              ),
              const Spacer(),
              Text(
                stat.value,
                style: AppTextStyles.heroTitle.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(stat.label, style: AppTextStyles.caption),
            ],
          ),
        );
      },
    );
  }
}

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    required this.title,
    required this.items,
    super.key,
  });

  final String title;
  final List<ProfileMenuItemData> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.84),
      radius: 28,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          for (var index = 0; index < items.length; index++) ...[
            ProfileMenuTile(item: items[index]),
            if (index != items.length - 1) ...[
              const SizedBox(height: 10),
              Divider(color: AppColors.charcoal.withValues(alpha: 0.08)),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({required this.item, super.key});

  final ProfileMenuItemData item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: item.onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.14),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.bodyStrong),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(item.subtitle!, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
          if (item.trailingLabel != null)
            AppChip(label: item.trailingLabel!, color: AppColors.fieldCool),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.84),
      radius: 28,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyStrong),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.white,
          activeTrackColor: AppColors.coral,
        ),
      ],
    );
  }
}

class SettingsRowItem extends StatelessWidget {
  const SettingsRowItem({
    required this.title,
    required this.value,
    super.key,
    this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdBorder,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.bodyStrong)),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(color: AppColors.muted),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}

class FaqCard extends StatelessWidget {
  const FaqCard({required this.question, required this.answer, super.key});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.82),
      radius: 24,
      shadow: AppShadows.softCard,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.bodyStrong),
          const SizedBox(height: 8),
          Text(answer, style: AppTextStyles.body.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

class SupportActionCard extends StatelessWidget {
  const SupportActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 26,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: AppRadius.mdBorder,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyStrong),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class ReportsStatusTabs extends StatelessWidget {
  const ReportsStatusTabs({
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.profileReportsTabActive,
      context.l10n.profileReportsTabReunited,
      context.l10n.profileReportsTabClosed,
    ];
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: InkWell(
              borderRadius: AppRadius.pillBorder,
              onTap: () => onChanged(index),
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.coral
                      : AppColors.glassSoft,
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: AppTextStyles.chip.copyWith(
                      color: currentIndex == index
                          ? AppColors.white
                          : AppColors.charcoal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (index != labels.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class ProfileEmptyReportsCard extends StatelessWidget {
  const ProfileEmptyReportsCard({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.glass,
      radius: 32,
      shadow: AppShadows.raisedCard,
      padding: const EdgeInsets.all(22),
      child: EmptyState(
        title: title,
        message: message,
        icon: Icons.bookmark_border,
        actionLabel: actionLabel,
        onActionPressed: onAction,
      ),
    );
  }
}

class ProfileMenuItemData {
  const ProfileMenuItemData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.trailingLabel,
  });

  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: AppAssetImage(
        assetPath: AppImages.profileAvatarDog,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
    );
  }
}

class _ProfileBackdrop extends StatelessWidget {
  const _ProfileBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -18,
          top: 84,
          child: _Glow(
            width: 180,
            height: 180,
            color: AppColors.teal.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          left: -40,
          top: 230,
          child: _Glow(
            width: 220,
            height: 220,
            color: AppColors.coral.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          right: 42,
          top: 210,
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
