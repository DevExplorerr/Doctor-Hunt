import 'package:doctor_hunt/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisAlignment: .center,
      children:
          List.generate(
              fullStars,
              (index) =>
                  const Icon(Icons.star, color: AppColors.review, size: 15),
            )
            ..addAll(
              halfStar
                  ? [
                      const Icon(
                        Icons.star_half,
                        color: AppColors.review,
                        size: 15,
                      ),
                    ]
                  : [],
            )
            ..addAll(
              List.generate(
                5 - fullStars - (halfStar ? 1 : 0),
                (index) =>
                    const Icon(Icons.star, color: AppColors.grey, size: 15),
              ),
            ),
    );
  }
}
