import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/pet_report_card.dart';
import '../../../mock/mock_data.dart';
import '../widgets/profile_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class SavedReportsScreen extends StatelessWidget {
  const SavedReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedReports = MockData.allReports
        .where((report) => MockData.savedReportIds.contains(report.id))
        .toList();

    return ProfileScaffold(
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
                ProfileHeader(
                  title: context.l10n.savedReportsTitle,
                  subtitle: context.l10n.savedReportsDesc,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () =>
                        context.safeBackNamed(AppRoute.profileOverview),
                  ),
                ),
                const SizedBox(height: 18),
                if (savedReports.isEmpty)
                  ProfileEmptyReportsCard(
                    title: context.l10n.savedReportsEmpty,
                    message: context.l10n.savedReportsSubtitle,
                    actionLabel: context.l10n.savedReportsExploreNearby,
                    onAction: () => context.goNamed(AppRoute.home.name),
                  )
                else
                  for (final report in savedReports) ...[
                    PetReportCard(
                      report: report,
                      onTap: () => context.goNamed(
                        AppRoute.reportDetail.name,
                        pathParameters: {'reportId': report.id},
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
