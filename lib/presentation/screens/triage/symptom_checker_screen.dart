import 'package:doctor_hunt/controllers/triage/symptom_checker_controller.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:doctor_hunt/presentation/screens/triage/widget/thinking_loader.dart';
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
            const CustomAppBar(title: "Symptom Checker"),
            Expanded(
              child: Container(
                color: AppColors.primary.withValues(alpha: 0.02),
                child: Obx(
                  () => ListView.builder(
                    controller: controller.scrollController,
                    padding: const .symmetric(horizontal: 15),
                    itemCount:
                        controller.messages.length +
                        (controller.isTyping.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.messages.length) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: .only(left: 45, bottom: 15),
                            child: ThinkingLoader(),
                          ),
                        );
                      }

                      final message = controller.messages[index];
                      final isUser = message["isUser"];

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
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? AppColors.primary
                                      : AppColors.white,
                                  borderRadius: .only(
                                    topLeft: const .circular(20),
                                    topRight: const .circular(20),
                                    bottomLeft: .circular(isUser ? 20 : 0),
                                    bottomRight: .circular(isUser ? 0 : 20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  message["text"],
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isUser
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser) const SizedBox(width: 5),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Container(
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
                child: Row(
                  crossAxisAlignment: .end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.05),
                          borderRadius: .circular(24),
                        ),
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            child: controller.isRecording.value
                                ? Padding(
                                    padding: const .symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          builder: (context, value, child) {
                                            return Opacity(
                                              opacity: value > 0.5 ? 1.0 : 0.2,
                                              child: child,
                                            );
                                          },
                                          onEnd: () {},
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                              color: AppColors.red,
                                              shape: .circle,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          controller.formattedTime,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: AppColors.red,
                                            fontWeight: .w700,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: controller.cancelRecording,
                                          child: Text(
                                            "Cancel",
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : CustomTextField(
                                    controller: controller.textController,
                                    hintText: "Type a message...",
                                    textInputAction: .newline,
                                    keyboardType: .multiline,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (!controller.isTextEmpty.value) {
                            controller.sendMessage();
                          } else if (controller.isRecording.value) {
                            controller.stopRecording();
                          } else {
                            controller.startRecording();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const .all(14),
                          decoration: BoxDecoration(
                            color: controller.isRecording.value
                                ? AppColors.red
                                : AppColors.primary,
                            shape: .circle,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              controller.isTextEmpty.value &&
                                      !controller.isRecording.value
                                  ? Icons.mic
                                  : (controller.isRecording.value
                                        ? Icons.stop
                                        : Icons.send),
                              key: ValueKey<bool>(
                                controller.isTextEmpty.value ||
                                    controller.isRecording.value,
                              ),
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
