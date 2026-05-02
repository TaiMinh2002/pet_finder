import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../mock/mock_data.dart';
import '../../domain/pet_model.dart';
import '../widgets/pets_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class EditPetProfileScreen extends StatefulWidget {
  const EditPetProfileScreen({required this.petId, super.key});

  final String petId;

  @override
  State<EditPetProfileScreen> createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  late final PetModel pet;
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _colorController;
  late final TextEditingController _weightController;
  late final TextEditingController _marksController;
  late final TextEditingController _microchipController;
  late final TextEditingController _vaccinationController;
  late final TextEditingController _notesController;

  late String _type;
  late String _gender;
  late String _age;
  var _reminderOn = true;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    pet = MockData.pets.firstWhere(
      (item) => item.id == widget.petId,
      orElse: () => MockData.pets.first,
    );
    _nameController = TextEditingController(text: pet.name);
    _breedController = TextEditingController(text: pet.breed);
    _colorController = TextEditingController(text: pet.color);
    _weightController = TextEditingController(text: pet.weightLabel);
    _marksController = TextEditingController(text: pet.specialMarks);
    _microchipController = TextEditingController(text: pet.microchipNumber);
    _vaccinationController = TextEditingController(text: pet.vaccinationStatus);
    _notesController = TextEditingController(text: pet.medicalNotes);
    _type = pet.type == PetType.dog
        ? context.l10n.petWidgetTypeDog
        : pet.type == PetType.cat
        ? context.l10n.petWidgetTypeCat
        : context.l10n.petWidgetTypeOther;
    _gender = pet.gender;
    _age = pet.ageLabel;
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    showPetSnackBar(
      context,
      'Pet profile updated.',
      icon: Icons.check_circle_outline,
      backgroundColor: AppColors.teal,
    );
    setState(() => _isSaving = false);
    context.goNamed(
      AppRoute.petsDetail.name,
      pathParameters: {'petId': pet.id},
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
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
                      title: context.l10n.petEditTitle,
                      subtitle: context.l10n.petEditSubtitle,
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
                      typeValue: _type,
                      genderValue: _gender,
                      ageValue: _age,
                      reminderValue: _reminderOn,
                      onTypeChanged: (value) => setState(() => _type = value),
                      onGenderChanged: (value) =>
                          setState(() => _gender = value),
                      onAgeChanged: (value) => setState(() => _age = value),
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
              label: context.l10n.petEditSaveBtn,
              isLoading: _isSaving,
              onPressed: _saveChanges,
              icon: Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }
}
