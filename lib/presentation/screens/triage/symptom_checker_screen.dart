import 'package:doctor_hunt/controllers/triage/symptom_checker_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/core/constants/specialties.dart';
import 'package:doctor_hunt/data/models/triage_response_model.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/emergency_warning_card.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/follow_up_chips.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/recording_panel.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/thinking_loader.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/triage_result_card.dart';
import 'package:doctor_hunt/presentation/widgets/header/custom_app_bar.dart';
import 'package:doctor_hunt/presentation/widgets/inputs/custom_text_field.dart';
import 'package:doctor_hunt/presentation/widgets/wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SymptomCheckerController controller = Get.put(
      SymptomCheckerController(),
    );
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MainWrapper(
        child: Column(
          children: [
            Obx(
              () => CustomAppBar(
                title: "Symptom Checker",
                showReset: controller.messages.length > 1,
                onReset: controller.startNewTriage,
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.primary.withValues(alpha: 0.02),
                child: Obx(() => _buildChatList(context, controller)),
              ),
            ),
            _buildInputBar(context, controller, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(
    BuildContext context,
    SymptomCheckerController controller,
  ) {
    final showThinking = controller.isTyping.value;
    final showResult = controller.isCompleted && !showThinking;
    final showEmergency = controller.isEmergency && !showThinking;

    final itemCount =
        controller.messages.length +
        (showThinking ? 1 : 0) +
        (showResult ? 1 : 0) +
        (showEmergency ? 1 : 0);

    return ListView.builder(
      controller: controller.scrollController,
      padding: const .symmetric(horizontal: 15),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final messageCount = controller.messages.length;

        if (index < messageCount) {
          return _buildMessageTile(
            context,
            controller,
            controller.messages[index],
            isLastMessage: index == messageCount - 1,
          );
        }

        var extra = index - messageCount;
        if (showThinking) {
          if (extra == 0) {
            return const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: .only(left: 45, bottom: 15),
                child: ThinkingLoader(),
              ),
            );
          }
          extra--;
        }
        if (showResult) {
          if (extra == 0) {
            return Padding(
              padding: const .only(bottom: 20),
              child: TriageResultCard(
                specialty: controller.specialty.value ?? Specialties.fallback,
                urgency: controller.urgency.value,
                triage: controller.triage.value,
                homeCare: controller.homeCare.value,
                showFindDoctors: !controller.isEmergency,
                onFindDoctors: controller.findDoctors,
                onStartNewCheck: controller.startNewTriage,
              ),
            );
          }
          extra--;
        }
        if (showEmergency && extra == 0) {
          return Padding(
            padding: const .only(bottom: 20),
            child: EmergencyWarningCard(
              onBrowseDoctors: controller.browseDoctors,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMessageTile(
    BuildContext context,
    SymptomCheckerController controller,
    ChatMessage message, {
    required bool isLastMessage,
  }) {
    final isUser = message.isUser;
    final showFollowUps =
        isLastMessage &&
        !isUser &&
        !controller.isTyping.value &&
        !controller.isCompleted &&
        controller.hasChipQuestions;

    return Column(
      crossAxisAlignment: .start,
      children: [
        _buildMessageBubble(context, message),
        if (showFollowUps)
          FollowUpChips(
            questions: controller.followUpQuestions.toList(),
            onSelected: controller.sendFollowUpAnswer,
          ),
      ],
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final textTheme = Theme.of(context).textTheme;
    final isUser = message.isUser;

    return Padding(
      padding: const .only(bottom: 20),
      child: Row(
        mainAxisAlignment: isUser ? .end : .start,
        crossAxisAlignment: .end,
        children: [
          if (!isUser) ...[
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const .symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.white,
                borderRadius: .only(
                  topLeft: const .circular(20),
                  topRight: const .circular(20),
                  bottomLeft: .circular(isUser ? 20 : 0),
                  bottomRight: .circular(isUser ? 0 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: isUser ? AppColors.white : AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    SymptomCheckerController controller,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const .all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const .only(
          topLeft: .circular(20),
          topRight: .circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isListening.value) {
            return RecordingPanel(
              onStop: controller.stopRecording,
              onCancel: controller.cancelRecording,
            );
          }
          return _buildIdleInput(context, controller, textTheme);
        }),
      ),
    );
  }

  Widget _buildIdleInput(
    BuildContext context,
    SymptomCheckerController controller,
    TextTheme textTheme,
  ) {
    return Column(
      mainAxisSize: .min,
      children: [
        Obx(() {
          if (controller.isCompleted) return const SizedBox.shrink();
          return Padding(
            padding: const .only(bottom: 8),
            child: Row(
              children: [
                _buildLanguageChip(
                  'EN',
                  controller.selectedSttLanguage.value == 'en',
                  controller.toggleSttLanguage,
                ),
                const SizedBox(width: 6),
                _buildLanguageChip(
                  '\u0627\u0631\u062F\u0648',
                  controller.selectedSttLanguage.value == 'ur',
                  controller.toggleSttLanguage,
                ),
              ],
            ),
          );
        }),
        Row(
          crossAxisAlignment: .end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.05),
                  borderRadius: .circular(24),
                ),
                child: Obx(
                  () => IgnorePointer(
                    ignoring: controller.isCompleted,
                    child: Opacity(
                      opacity: controller.isCompleted ? 0.5 : 1.0,
                      child: CustomTextField(
                        controller: controller.textController,
                        hintText: controller.isCompleted
                            ? "Start a new check to chat again"
                            : "Type a message...",
                        textInputAction: .newline,
                        keyboardType: .multiline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() {
              final isBusy = controller.isTyping.value;
              final isCompleted = controller.isCompleted;
              final canSend =
                  !isBusy && !isCompleted && !controller.isTextEmpty.value;

              return GestureDetector(
                onTap: isBusy
                    ? null
                    : () {
                        if (isCompleted) {
                          controller.startNewTriage();
                        } else if (canSend) {
                          controller.sendMessage();
                        } else {
                          controller.onMicPressed();
                        }
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const .all(14),
                  decoration: BoxDecoration(
                    color: isBusy
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : AppColors.primary,
                    shape: .circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isCompleted
                          ? Icons.refresh_rounded
                          : canSend
                          ? Icons.send
                          : Icons.mic,
                      key: ValueKey<String>('$isCompleted-$canSend'),
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const .symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.secondary.withValues(alpha: 0.05),
          borderRadius: .circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
