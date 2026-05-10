import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../widgets/pets_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class MyPetsEmptyScreen extends StatelessWidget {
  const MyPetsEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PetsScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenNarrow,
          20,
          AppSpacing.screenNarrow,
          118,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PetsHeader(
              title: context.l10n.petEmptyTitle,
              subtitle: context.l10n.petListSubtitle,
              leading: CircleGlassButton(
                icon: Icons.arrow_back,
                onTap: () => context.safeBackNamed(AppRoute.petsList),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Center(
                child: PetsEmptyCard(
                  onAdd: () => context.goNamed(AppRoute.petsAdd.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
