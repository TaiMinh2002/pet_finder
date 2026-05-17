import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../../../../core/widgets/pet_profile_card.dart';
import '../../domain/pet_model.dart';
import '../bloc/pets_cubit.dart';
import '../bloc/pets_state.dart';
import '../widgets/pets_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class MyPetsListScreen extends StatefulWidget {
  const MyPetsListScreen({super.key, this.useEmptyState = false});

  final bool useEmptyState;

  @override
  State<MyPetsListScreen> createState() => _MyPetsListScreenState();
}

class _MyPetsListScreenState extends State<MyPetsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.useEmptyState) return;
      context.read<PetsCubit>().loadUserPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PetsScaffold(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenNarrow,
              20,
              AppSpacing.screenNarrow,
              118,
            ),
            sliver: SliverList.list(
              children: [
                PetsHeader(
                  title: context.l10n.petEmptyTitle,
                  subtitle: context.l10n.petListSubtitle,
                  trailing: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: AppRadius.lgBorder,
                      boxShadow: AppShadows.primaryButton,
                    ),
                    child: InkWell(
                      borderRadius: AppRadius.lgBorder,
                      onTap: () => context.goNamed(AppRoute.petsAdd.name),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.petListAddBtn,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: AppRadius.lgBorder,
                    boxShadow: AppShadows.softCard,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppColors.teal,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.petListSummary,
                          style: AppTextStyles.bodyStrong.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<PetsCubit, PetsState>(
                  builder: (context, state) {
                    if (widget.useEmptyState || state is PetsEmpty) {
                      return PetsEmptyCard(
                        onAdd: () => context.goNamed(AppRoute.petsAdd.name),
                      );
                    }
                    if (state is PetsInitial || state is PetsLoading) {
                      return AppLoadingState(
                        title: context.l10n.petEmptyTitle,
                        message: context.l10n.petListSubtitle,
                      );
                    }
                    if (state is PetsError) {
                      return AppErrorState(
                        title: context.l10n.petEmptyTitle,
                        message: state.message,
                        onRetry: () => context.read<PetsCubit>().loadUserPets(),
                      );
                    }
                    final pets = state is PetsLoaded
                        ? state.pets
                        : const <PetModel>[];
                    return Column(
                      children: [
                        for (final pet in pets) ...[
                          PetProfileCard(
                            pet: pet,
                            onTap: () => context.goNamed(
                              AppRoute.petsDetail.name,
                              pathParameters: {'petId': pet.id},
                            ),
                            onReportLost: () => context.goNamed(
                              AppRoute.reportCreate.name,
                              queryParameters: const {'type': 'lost'},
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        const SizedBox(height: 4),
                        AppButton(
                          label: context.l10n.petListPreviewEmpty,
                          onPressed: () =>
                              context.goNamed(AppRoute.petsEmpty.name),
                          icon: Icons.visibility_outlined,
                          variant: AppButtonVariant.secondary,
                          height: 48,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
