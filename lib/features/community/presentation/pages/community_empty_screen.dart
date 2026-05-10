import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../widgets/community_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class CommunityEmptyScreen extends StatelessWidget {
  const CommunityEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommunityScaffold(
      bottomNav: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenNarrow,
          18,
          AppSpacing.screenNarrow,
          40,
        ),
        child: Column(
          children: [
            CommunityHeader(
              title: context.l10n.communityTitle,
              subtitle: context.l10n.communityEmptyDesc,
              leading: CircleGlassButton(
                icon: Icons.arrow_back,
                onTap: () => context.safeBackNamed(AppRoute.communityFeed),
              ),
            ),
            const Spacer(),
            CommunityEmptyCard(
              onCreatePost: () =>
                  context.goNamed(AppRoute.communityCreate.name),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
