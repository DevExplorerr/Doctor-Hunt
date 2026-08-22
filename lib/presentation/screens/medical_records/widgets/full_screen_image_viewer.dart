import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final displayUrl = imageUrl.toLowerCase().endsWith('.pdf')
        ? imageUrl.replaceAll(RegExp(r'\.pdf$'), '.jpg')
        : imageUrl;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: displayUrl,
            width: .infinity,
            height: .infinity,
            fit: .contain,
            placeholder: (context, url) =>
                LoadingAnimationWidget.threeArchedCircle(
                  color: AppColors.primary,
                  size: 40,
                ),
            errorWidget: (context, url, error) => const Column(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.broken_image, color: AppColors.icon, size: 50),
                SizedBox(height: 10),
                Text(
                  "Could not load preview",
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
