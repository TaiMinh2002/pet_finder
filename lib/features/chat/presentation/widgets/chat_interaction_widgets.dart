import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/navigation/navigation_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../mock/mock_data.dart';
import '../../domain/chat_model.dart';
import 'chat_widgets.dart';
import 'package:pet_finder/core/localization/localization_extensions.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    required this.controller,
    required this.onSend,
    super.key,
    this.isSending = false,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.white.withValues(alpha: 0.88),
      radius: 30,
      shadow: AppShadows.floating,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.fieldWarm,
              borderRadius: AppRadius.cardBorder,
            ),
            child: const Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.coral,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isSending,
              style: AppTextStyles.bodyStrong,
              decoration: InputDecoration(
                hintText: context.l10n.chatComposerHint,
                hintStyle: AppTextStyles.caption.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppColors.fieldWarm,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.pillBorder,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: isSending ? null : onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppGradients.coralButton,
                shape: BoxShape.circle,
                boxShadow: AppShadows.primaryButton,
              ),
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactQuickActionSheet extends StatelessWidget {
  const ContactQuickActionSheet({
    required this.chat,
    required this.onOpenChat,
    required this.onViewReport,
    super.key,
  });

  final ChatModel chat;
  final VoidCallback onOpenChat;
  final VoidCallback onViewReport;

  @override
  Widget build(BuildContext context) {
    final pet = MockData.tryResolvePet(chat.petId) ?? MockData.pets.first;
    final actions = <({String label, IconData icon, Color color})>[
      (
        label: context.l10n.chatCall,
        icon: Icons.call_outlined,
        color: AppColors.coral,
      ),
      (
        label: context.l10n.chatActionSms,
        icon: Icons.sms_outlined,
        color: AppColors.teal,
      ),
      (
        label: context.l10n.chatActionInApp,
        icon: Icons.chat_bubble_outline,
        color: AppColors.green,
      ),
      (
        label: context.l10n.chatActionShareReport,
        icon: Icons.share_outlined,
        color: AppColors.coralDark,
      ),
      (
        label: context.l10n.chatViewReport,
        icon: Icons.visibility_outlined,
        color: AppColors.charcoal,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.charcoal.withValues(alpha: 0.12),
                borderRadius: AppRadius.pillBorder,
              ),
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            color: AppColors.white,
            radius: 26,
            shadow: AppShadows.softCard,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ChatAvatar(pet: pet, role: chat.role, size: 54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat.contactName, style: AppTextStyles.title),
                      const SizedBox(height: 4),
                      Text(
                        '${chat.petName} • ${chat.reportTitle}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                AppChip(
                  label: context.l10n.chatActionActive,
                  color: AppColors.fieldWarm,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];
              final callback = switch (index) {
                0 => () => _showSheetSnack(
                  context,
                  context.l10n.chatCallingName(chat.contactName),
                ),
                1 => () => _showSheetSnack(
                  context,
                  context.l10n.chatOpeningSmsComposer,
                ),
                2 => onOpenChat,
                3 => () => _showSheetSnack(
                  context,
                  context.l10n.chatSharingReport,
                ),
                _ => onViewReport,
              };
              return AppCard(
                color: AppColors.white,
                radius: 24,
                shadow: AppShadows.softCard,
                padding: const EdgeInsets.all(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: callback,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: action.color.withValues(alpha: 0.12),
                          borderRadius: AppRadius.mdBorder,
                        ),
                        child: Icon(action.icon, color: action.color),
                      ),
                      const SizedBox(height: 12),
                      Text(action.label, style: AppTextStyles.bodyStrong),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            label: context.l10n.commonClose,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.safeClose(),
          ),
        ],
      ),
    );
  }
}

void _showSheetSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      backgroundColor: AppColors.charcoal,
      content: Text(
        message,
        style: AppTextStyles.caption.copyWith(color: AppColors.white),
      ),
    ),
  );
}
