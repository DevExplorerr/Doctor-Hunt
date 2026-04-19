import 'package:flutter/material.dart';

class CustomHeadline extends StatelessWidget {
  final bool onlyText;
  final VoidCallback? onPressed;
  final String text;
  const CustomHeadline({
    super.key,
    this.onPressed,
    required this.text,
    required this.onlyText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return onlyText
        ? Text(text, style: textTheme.titleMedium?.copyWith(fontWeight: .w700))
        : Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                text,
                style: textTheme.titleMedium?.copyWith(fontWeight: .w700),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text("See all >", style: textTheme.bodySmall),
              ),
            ],
          );
  }
}
