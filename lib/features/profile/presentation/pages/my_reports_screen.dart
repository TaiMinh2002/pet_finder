import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/pet_report_card.dart';
import '../../../mock/mock_data.dart';
import '../../../reports/domain/pet_report_model.dart';
import '../widgets/profile_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final reports = switch (selectedIndex) {
      0 =>
        MockData.myReports
            .where((item) => item.status == PetReportStatus.active)
            .toList(),
      1 =>
        MockData.myReports
            .where((item) => item.status == PetReportStatus.resolved)
            .toList(),
      _ =>
        MockData.myReports
            .where((item) => item.status == PetReportStatus.closed)
            .toList(),
    };

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
                  title: context.l10n.myReportsTitle,
                  subtitle: context.l10n.myReportsDesc,
                  leading: CircleGlassButton(
                    icon: Icons.arrow_back,
                    onTap: () =>
                        context.safeBackNamed(AppRoute.profileOverview),
                  ),
                ),
                const SizedBox(height: 18),
                ReportsStatusTabs(
                  currentIndex: selectedIndex,
                  onChanged: (index) => setState(() => selectedIndex = index),
                ),
                const SizedBox(height: 18),
                if (reports.isEmpty)
                  ProfileEmptyReportsCard(
                    title: context.l10n.myReportsEmpty,
                    message: context.l10n.myReportsSubtitle,
                    actionLabel: context.l10n.commonBackToProfile,
                    onAction: () =>
                        context.safeBackNamed(AppRoute.profileOverview),
                  )
                else
                  for (final report in reports) ...[
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
