import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/community_post_model.dart';
import '../widgets/community_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class CreateCommunityPostScreen extends StatefulWidget {
  const CreateCommunityPostScreen({super.key});

  @override
  State<CreateCommunityPostScreen> createState() =>
      _CreateCommunityPostScreenState();
}

class _CreateCommunityPostScreenState extends State<CreateCommunityPostScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  var _selectedCategory = CommunityCategory.safetyTips;
  var _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _publishPost() async {
    if (_isPublishing) return;
    setState(() => _isPublishing = true);
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    showPetSnackBar(
      context,
      context.l10n.communityPostShared,
      icon: Icons.groups_2_outlined,
      backgroundColor: AppColors.coral,
    );
    setState(() => _isPublishing = false);
    context.goNamed(AppRoute.communityFeed.name);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return CommunityScaffold(
      bottomNav: false,
      child: Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenNarrow,
                  18,
                  AppSpacing.screenNarrow,
                  126 + bottomInset,
                ),
                sliver: SliverList.list(
                  children: [
                    CommunityHeader(
                      title: context.l10n.communityCreateTitle,
                      subtitle: context.l10n.communityCreateSubtitle,
                      leading: CircleGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () =>
                            context.safeBackNamed(AppRoute.communityFeed),
                      ),
                    ),
                    const SizedBox(height: 18),
                    CommunityComposerCard(
                      titleController: _titleController,
                      bodyController: _bodyController,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) =>
                          setState(() => _selectedCategory = category),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: AppSpacing.screenNarrow,
            right: AppSpacing.screenNarrow,
            bottom: 28 + bottomInset,
            child: AppButton(
              label: context.l10n.communityPublishBtn,
              icon: Icons.send_rounded,
              isLoading: _isPublishing,
              onPressed: _publishPost,
            ),
          ),
        ],
      ),
    );
  }
}
