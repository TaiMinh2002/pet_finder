import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/pets_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class AddPetProfileScreen extends StatefulWidget {
  const AddPetProfileScreen({super.key});

  @override
  State<AddPetProfileScreen> createState() => _AddPetProfileScreenState();
}

class _AddPetProfileScreenState extends State<AddPetProfileScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _marksController = TextEditingController();
  final _microchipController = TextEditingController();
  final _vaccinationController = TextEditingController();
  final _notesController = TextEditingController();

  var _type = 'dog';
  var _gender = 'female';
  var _age = '2y';
  var _reminderOn = true;
  var _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _marksController.dispose();
    _microchipController.dispose();
    _vaccinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    showPetSnackBar(
      context,
      'Pet profile saved. You can report as lost faster now.',
      icon: Icons.pets,
    );
    setState(() => _isSaving = false);
    context.goNamed(AppRoute.petsList.name);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final localizedType = switch (_type) {
      'dog' => context.l10n.petWidgetTypeDog,
      'cat' => context.l10n.petWidgetTypeCat,
      _ => context.l10n.petWidgetTypeOther,
    };
    final localizedGender = switch (_gender) {
      'female' => context.l10n.petWidgetGenderFemale,
      'male' => context.l10n.petWidgetGenderMale,
      _ => context.l10n.petWidgetGenderFemale,
    };
    final localizedAge = _age == '11m'
        ? context.l10n.petAgeElevenMonths
        : context.l10n.petAgeTwoYears;
    return PetsScaffold(
      bottomNav: false,
      child: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  20,
                  AppSpacing.screenNarrow,
                  116 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    PetsHeader(
                      title: context.l10n.petAddTitle,
                      subtitle: context.l10n.petAddSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.safeBackNamed(AppRoute.petsList),
                      ),
                    ),
                    const SizedBox(height: 18),
                    PetFormFields(
                      nameController: _nameController,
                      breedController: _breedController,
                      colorController: _colorController,
                      weightController: _weightController,
                      marksController: _marksController,
                      microchipController: _microchipController,
                      vaccinationController: _vaccinationController,
                      notesController: _notesController,
                      typeValue: localizedType,
                      genderValue: localizedGender,
                      ageValue: localizedAge,
                      reminderValue: _reminderOn,
                      onTypeChanged: (value) => setState(() {
                        _type = switch (value) {
                          String v when v == context.l10n.petWidgetTypeDog =>
                            'dog',
                          String v when v == context.l10n.petWidgetTypeCat =>
                            'cat',
                          _ => 'other',
                        };
                      }),
                      onGenderChanged: (value) => setState(() {
                        _gender = value == context.l10n.petWidgetGenderMale
                            ? 'male'
                            : 'female';
                      }),
                      onAgeChanged: (value) => setState(() {
                        _age = value == context.l10n.petAgeElevenMonths
                            ? '11m'
                            : '2y';
                      }),
                      onReminderChanged: (value) =>
                          setState(() => _reminderOn = value),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24 + bottomInset,
            child: AppButton(
              label: context.l10n.petAddSaveBtn,
              isLoading: _isSaving,
              onPressed: _savePet,
              icon: Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }
}
