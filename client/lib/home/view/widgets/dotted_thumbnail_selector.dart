import 'package:client/core/constants/strings.dart';
import 'package:client/core/extensions/app_context.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

/// selects a thumbnail for the song upload
class DottedThumbnailSelector extends StatelessWidget {
  /// Creates a [DottedThumbnailSelector] widget.
  const DottedThumbnailSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final sizedBox = SizedBox(height: context.height * 0.01);
    return DottedBorder(
      options: const RoundedRectDottedBorderOptions(
        strokeCap: StrokeCap.round,
        radius: Radius.circular(10),
        dashPattern: [10, 4],
        color: Palette.borderColor,
      ),
      child: SizedBox(
        height: context.height * 0.20,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 40, color: Palette.greyColor),
            sizedBox,
            Text(
              selectThumbnail,
              style: context.textTheme.titleMedium?.copyWith(
                color: Palette.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
