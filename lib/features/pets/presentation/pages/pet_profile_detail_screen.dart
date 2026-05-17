import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_status_views.dart';
import '../bloc/pets_cubit.dart';
import '../bloc/pets_state.dart';
import '../widgets/pets_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class PetProfileDetailScreen extends StatefulWidget {
  const PetProfileDetailScreen({required this.petId, super.key});

  final String petId;

  @override
  State<PetProfileDetailScreen> createState() => _PetProfileDetailScreenState();
}

class _PetProfileDetailScreenState extends State<PetProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PetsCubit>().loadPet(widget.petId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetsCubit, PetsState>(
      builder: (context, state) {
        if (state is PetsLoading || state is PetsInitial) {
          return PetsScaffold(
            bottomNav: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenNarrow,
                18,
                AppSpacing.screenNarrow,
                40,
              ),
              child: AppLoadingState(
                title: context.l10n.petEmptyTitle,
                message: context.l10n.petListSubtitle,
              ),
            ),
          );
        }
        if (state is PetsError || state is! PetLoaded) {
          return PetsScaffold(
            bottomNav: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenNarrow,
                18,
                AppSpacing.screenNarrow,
                40,
              ),
              child: AppErrorState(
                title: context.l10n.petDetailNotFoundTitle,
                message: state is PetsError
                    ? state.message
                    : context.l10n.petDetailNotFoundDesc,
                retryLabel: 'Back to Pets',
                onRetry: () => context.goNamed(AppRoute.petsList.name),
              ),
            ),
          );
        }

        final pet = state.pet;
        return PetsScaffold(
          bottomNav: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    PetHeroCard(pet: pet),
                    Positioned(
                      left: 24,
                      top: 18,
                      child: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.safeBackNamed(AppRoute.petsList),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 18,
                      child: CircleGlassButton(
                        icon: Icons.edit_outlined,
                        onTap: () => context.goNamed(
                          AppRoute.petsEdit.name,
                          pathParameters: {'petId': pet.id},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  0,
                  AppSpacing.screenNarrow,
                  110,
                ),
                sliver: SliverList.list(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.name, style: AppTextStyles.heroTitle),
                            const SizedBox(height: 6),
                            Text(
                              '${pet.breed} • ${pet.ageLabel} • ${pet.weightLabel}',
                              style: AppTextStyles.body.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                AppChip(
                                  label: pet.profileStatus,
                                  color: AppColors.glass,
                                ),
                                ReminderTag(label: pet.reminderLabel),
                              ],
                            ),
                            const SizedBox(height: 18),
                            ProfileSectionCard(
                              title: context.l10n.petDetailBasicSection,
                              rows: [
                                (context.l10n.petWidgetType, pet.type.name),
                                (context.l10n.petWidgetGender, pet.gender),
                                ('Birthdate / age', pet.birthLabel),
                                (context.l10n.petWidgetColor, pet.color),
                                (context.l10n.petWidgetWeight, pet.weightLabel),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ProfileSectionCard(
                              title: context.l10n.petDetailIdSection,
                              rows: [
                                (context.l10n.petWidgetBreed, pet.breed),
                                ('Special marks', pet.specialMarks),
                                ('Microchip', pet.microchipNumber),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ProfileSectionCard(
                              title: context.l10n.petDetailHealthSection,
                              rows: [
                                (
                                  context.l10n.reminderTypeVaccination,
                                  pet.vaccinationStatus,
                                ),
                                (
                                  context.l10n.petWidgetMedicalNotes,
                                  pet.medicalNotes,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ProfileSectionCard(
                              title: context.l10n.reminderOverviewTitle,
                              rows: [('Next reminder', pet.reminderLabel)],
                            ),
                            const SizedBox(height: 10),
                            AppButton(
                              label: context.l10n.petDetailOpenReminders,
                              icon: Icons.calendar_month,
                              variant: AppButtonVariant.secondary,
                              onPressed: () => context.goNamed(
                                AppRoute.remindersOverview.name,
                              ),
                            ),
                            const SizedBox(height: 14),
                            EmergencyCard(
                              onReportLost: () => context.goNamed(
                                AppRoute.reportCreate.name,
                                queryParameters: const {'type': 'lost'},
                              ),
                              onEdit: () => context.goNamed(
                                AppRoute.petsEdit.name,
                                pathParameters: {'petId': pet.id},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
