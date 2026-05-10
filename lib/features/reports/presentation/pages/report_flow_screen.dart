import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../mock/mock_data.dart';
import '../../domain/pet_report_model.dart';
import '../models/report_draft.dart';
import '../widgets/report_flow_widgets.dart';
part '../widgets/report_flow_steps.dart';

class ReportFlowScreen extends StatefulWidget {
  const ReportFlowScreen({super.key, this.initialType});

  final PetReportType? initialType;

  @override
  State<ReportFlowScreen> createState() => _ReportFlowScreenState();
}

class _ReportFlowScreenState extends State<ReportFlowScreen> {
  late ReportDraft _draft;
  var _step = 0;
  var _isPublishing = false;

  late final TextEditingController _petNameController;
  late final TextEditingController _breedController;
  late final TextEditingController _colorController;
  late final TextEditingController _marksController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _altController;

  @override
  void initState() {
    super.initState();
    _draft = ReportDraft(type: widget.initialType ?? PetReportType.lost);
    _petNameController = TextEditingController(text: _draft.petName);
    _breedController = TextEditingController(text: _draft.breed);
    _colorController = TextEditingController(text: _draft.color);
    _marksController = TextEditingController(text: _draft.specialMarks);
    _addressController = TextEditingController(text: _draft.address);
    _phoneController = TextEditingController(text: _draft.phone);
    _altController = TextEditingController(text: _draft.altContact);
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _marksController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _altController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_step == 5) {
      _captureControllers();
    }
    if (_step < 6) {
      setState(() => _step += 1);
    }
  }

  void _goBack() {
    if (_step == 0) {
      context.safeBackNamed(AppRoute.home);
      return;
    }
    setState(() => _step -= 1);
  }

  void _captureControllers() {
    _draft = _draft.copyWith(
      petName: _petNameController.text,
      breed: _breedController.text,
      color: _colorController.text,
      specialMarks: _marksController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      altContact: _altController.text,
    );
  }

  Future<void> _publish() async {
    if (_isPublishing) return;
    setState(() => _isPublishing = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.reportFlowPublishSuccess,
      icon: Icons.campaign_outlined,
      backgroundColor: AppColors.coral,
    );
    setState(() => _isPublishing = false);
    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      0 => ReportFlowChooseTypeStep(
        draft: _draft,
        onTypeChanged: (type) =>
            setState(() => _draft = _draft.copyWith(type: type)),
        onNext: _goNext,
      ),
      1 => ReportFlowUploadPhotosStep(
        draft: _draft,
        onBack: _goBack,
        onNext: _goNext,
      ),
      2 => ReportFlowPetInformationStep(
        draft: _draft,
        petNameController: _petNameController,
        breedController: _breedController,
        colorController: _colorController,
        marksController: _marksController,
        onBack: _goBack,
        onNext: () {
          _captureControllers();
          _goNext();
        },
        onTypeChanged: (value) =>
            setState(() => _draft = _draft.copyWith(petType: value)),
        onGenderChanged: (value) =>
            setState(() => _draft = _draft.copyWith(gender: value)),
      ),
      3 => ReportFlowLocationTimeStep(
        draft: _draft,
        addressController: _addressController,
        onBack: _goBack,
        onNext: () {
          _captureControllers();
          _goNext();
        },
        onDateChanged: (value) =>
            setState(() => _draft = _draft.copyWith(dateLabel: value)),
        onTimeChanged: (value) =>
            setState(() => _draft = _draft.copyWith(timeLabel: value)),
      ),
      4 => ReportFlowContactInfoStep(
        draft: _draft,
        phoneController: _phoneController,
        altController: _altController,
        onBack: _goBack,
        onNext: () {
          _captureControllers();
          _goNext();
        },
        onVisibilityChanged: (value) =>
            setState(() => _draft = _draft.copyWith(isPhoneVisible: value)),
      ),
      5 => ReportFlowReviewStep(
        draft: _draft,
        isPublishing: _isPublishing,
        onBack: _goBack,
        onPublish: _publish,
      ),
      _ => ReportFlowSuccessStep(
        draft: _draft,
        onGoHome: () => context.goNamed(AppRoute.home.name),
        onViewReport: () {
          final fallback = MockData.allReports.first;
          final matched = MockData.allReports.firstWhere(
            (item) => item.type == _draft.type,
            orElse: () => fallback,
          );
          context.goNamed(
            AppRoute.reportDetail.name,
            pathParameters: {'reportId': matched.id},
          );
        },
      ),
    };
  }
}
