// lib/core/widgets/app_dialog.dart

import 'package:client/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// A fully customisable skeleton dialog used throughout the application.
///
/// ---
/// ## Permanent components
///
/// The four building blocks are always supported but **never mandatory**.
/// Pass `null` (or omit) any of them to exclude that section entirely:
/// ---
/// ## Layout variants
///
/// Control the vertical order of [AppDialog.title], [AppDialog.subtitle] and
/// [AppDialog.image] using [AppDialog.imagePosition]:
///
/// - [ImagePosition.aboveText]  → image first, then title, subtitle, buttons
/// - [ImagePosition.belowText]  → title, subtitle, image,
///    then buttons  *(default)*
///
/// ---
/// ## Button styles
///
/// | Style                        | Background             | Text   |
/// |------------------------------|------------------------|--------|
/// | [AppDialogButton.yes]        | Gradient (gradient1→2) | White  |
/// | [AppDialogButton.no]         | White                  | Black  |
///
/// Set `fullWidth: true` on any button for a full-width pill shape.
///
/// ---
/// ## Common usage patterns
///
/// **Pattern A – title + subtitle + image + 2 buttons (e.g. logout confirm)**
/// ```dart
/// showAppDialog(context, AppDialog(
///   title: 'Log out?',
///   subtitle: 'You will be signed out of your account.',
///   image: Image.asset(MediaRes.logoutIllustration, height: 140),
///   buttons: [
///     AppDialogButton.no(text: 'Cancel',  onTap: () =>
///     Navigator.pop(context)),
///     AppDialogButton.yes(text: 'Log out', onTap: _handleLogout),
///   ],
/// ));
/// ```
///
/// **Pattern B – image first, then title + subtitle + 2 buttons**
/// ```dart
/// showAppDialog(context, AppDialog(
///   imagePosition: ImagePosition.aboveText,
///   image: Image.asset(MediaRes.successIllustration, height: 120),
///   title: 'Track saved!',
///   subtitle: 'Your track has been added to the library.',
///   buttons: [
///     AppDialogButton.no(text: 'Dismiss', onTap: () =>
///     Navigator.pop(context)),
///     AppDialogButton.yes(text: 'View', onTap: _navigateToLibrary),
///   ],
/// ));
/// ```
///
/// **Pattern C – title + image + 1 full-width gradient button**
/// ```dart
/// showAppDialog(context, AppDialog(
///   title: 'All done!',
///   image: Icon(Icons.check_circle, size: 80, color: Palette.gradient2),
///   buttons: [
///     AppDialogButton.yes(text: 'Continue', onTap:
///   _onContinue, fullWidth: true),
///   ],
/// ));
/// ```
///
/// **Pattern D – subtitle + buttons only (no image, no title)**
/// ```dart
/// showAppDialog(context, AppDialog(
///   subtitle: 'Are you sure you want to delete this track?',
///   buttons: [
///     AppDialogButton.no(text: 'Cancel', onTap: () => Navigator.pop(context)),
///     AppDialogButton.yes(text: 'Delete', onTap: _deleteTrack),
///   ],
/// ));
/// ```
///
/// **Pattern E – image only (celebration / error screen)**
/// ```dart
/// showAppDialog(context, AppDialog(
///   image: Image.asset(MediaRes.partyIllustration, height: 180),
/// ));
/// ```
Future<T?> showAppDialog<T>(BuildContext context, AppDialog dialog) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => dialog,
  );
}

// ─── Supporting enums & models ───────────────────────────────────────────────

/// Controls where [AppDialog.image] is rendered relative to the text section.
enum ImagePosition {
  /// Image renders **below** the title/subtitle block, just above the buttons.
  /// This is the default layout.
  belowText,

  /// Image renders **above** the title/subtitle block, at the top of the dialog.
  aboveText,
}

/// Describes a single action button rendered inside [AppDialog].
///
/// Use the named constructors [AppDialogButton.yes] and [AppDialogButton.no]
/// to apply the two standard visual styles that match the application's
/// sign-in / sign-up button aesthetic.
class AppDialogButton {
  /// Creates an [AppDialogButton] with explicit style control.
  ///
  /// Prefer using [AppDialogButton.yes] or [AppDialogButton.no] for
  /// consistent styling across the app.
  const AppDialogButton({
    required this.text,
    required this.onTap,
    this.isGradient = true,
    this.fullWidth = false,
  });

  /// **"Yes / Confirm" button** – gradient background (gradient1 → gradient2),
  /// white bold text. Matches the sign-in / sign-up button style.
  ///
  /// - [text]      : Label displayed on the button.
  /// - [onTap]     : Callback fired when the button is tapped.
  /// - [fullWidth] : When `true`, the button expands to fill the full dialog
  ///                 width with large rounded corners (pill shape).
  factory AppDialogButton.yes({
    required String text,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) => AppDialogButton(text: text, onTap: onTap, fullWidth: fullWidth);

  /// **"No / Cancel" button** – white background, black bold text.
  ///
  /// - [text]      : Label displayed on the button.
  /// - [onTap]     : Callback fired when the button is tapped.
  /// - [fullWidth] : When `true`, the button expands to fill the full dialog
  ///                 width with large rounded corners (pill shape).
  factory AppDialogButton.no({
    required String text,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) => AppDialogButton(
    text: text,
    onTap: onTap,
    isGradient: false,
    fullWidth: fullWidth,
  );

  /// The label displayed on the button. **Required – never hard-coded.**
  final String text;

  /// The callback executed when the button is tapped.
  final VoidCallback onTap;

  /// When `true`  → gradient background + white text  (primary / "yes" look).
  /// When `false` → white background + black text     (secondary / "no" look).
  final bool isGradient;

  /// When `true` the button stretches to fill the full dialog width and uses
  /// larger rounded corners (pill shape). Ideal for single-button dialogs.
  final bool fullWidth;
}

// ─── Main dialog widget ──────────────────────────────────────────────────────

/// The skeleton dialog widget used throughout the application.
///
/// All four permanent components ([title], [subtitle], [image], [buttons])
/// are optional — pass only the ones required for the current use case.
///
/// The dialog background uses a dark gradient card colour that
/// complements the app's overall dark theme. A subtle glow border using
/// [Palette.gradient2] gives it an on-brand premium feel.
///
/// See [showAppDialog] for a convenience helper that wraps this widget
/// in a [showDialog] call with a dimmed barrier.
class AppDialog extends StatelessWidget {
  /// Creates an [AppDialog].
  ///
  /// All parameters are optional. Pass only the components you need;
  /// unused slots are completely omitted from the rendered layout.
  const AppDialog({
    super.key,
    // ── 4 permanent components ──────────────────────────
    this.title,
    this.subtitle,
    this.image,
    this.buttons = const [],
    // ── layout control ──────────────────────────────────
    this.imagePosition = ImagePosition.belowText,
    this.buttonAxis = Axis.horizontal,
    // ── optional style overrides ─────────────────────────
    this.titleStyle,
    this.subtitleStyle,
    this.imagePadding,
    this.contentPadding,
    this.buttonSpacing,
    this.dialogBorderRadius,
    this.backgroundGradient,
  });

  // ── Permanent component 1 ─────────────────────────────────────────────────

  /// **Heading text** – rendered bold and white at the top of the text block.
  ///
  /// Pass `null` (default) to omit the title entirely.
  final String? title;

  // ── Permanent component 2 ─────────────────────────────────────────────────

  /// **Subtitle / body copy** – rendered in a muted colour below [title].
  ///
  /// Pass `null` (default) to omit the subtitle entirely.
  final String? subtitle;

  // ── Permanent component 3 ─────────────────────────────────────────────────

  /// **Visual / illustration** – any widget centred inside the dialog.
  ///
  /// Accepts `Image.asset(…)`, `Icon(…)`, `Lottie.asset(…)`, or any
  /// other widget. Its position relative to the text block is controlled
  /// by [imagePosition]. Pass `null` (default) to omit entirely.
  final Widget? image;

  // ── Permanent component 4 ─────────────────────────────────────────────────

  /// **Action buttons** – a list of [AppDialogButton] instances.
  ///
  /// Two buttons are laid out side-by-side (horizontal) by default.
  /// Switch to a stacked layout via [buttonAxis]. Pass an empty list
  /// (the default) to render no buttons at all.
  final List<AppDialogButton> buttons;

  // ── Layout control ────────────────────────────────────────────────────────

  /// Controls where [image] is placed relative to the title/subtitle block.
  ///
  /// - [ImagePosition.belowText]  → title → subtitle →
  ///   image → buttons *(default)*
  /// - [ImagePosition.aboveText]  → image → title → subtitle → buttons
  final ImagePosition imagePosition;

  /// Layout direction for the buttons section.
  ///
  /// - [Axis.horizontal] → buttons appear side by side *(default, ideal for 2)*
  /// - [Axis.vertical]   → buttons stack vertically    *(ideal for 3 or more)*
  final Axis buttonAxis;

  // ── Optional style overrides ──────────────────────────────────────────────

  /// Overrides the default [title] text style.
  final TextStyle? titleStyle;

  /// Overrides the default [subtitle] text style.
  final TextStyle? subtitleStyle;

  /// Padding applied around the [image] widget.
  /// Defaults to `EdgeInsets.symmetric(vertical: 16)`.
  final EdgeInsetsGeometry? imagePadding;

  /// Inner padding of the entire dialog card.
  /// Defaults to `EdgeInsets.all(24)`.
  final EdgeInsetsGeometry? contentPadding;

  /// Gap between buttons. Defaults to `12.0`.
  final double? buttonSpacing;

  /// Corner radius of the dialog card. Defaults to `BorderRadius.circular(20)`.
  final BorderRadiusGeometry? dialogBorderRadius;

  /// Overrides the gradient used for the dialog card background.
  /// Defaults to a subtle dark gradient that matches [Palette.cardColor].
  final Gradient? backgroundGradient;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = buttonSpacing ?? 12.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              backgroundGradient ??
              const LinearGradient(
                colors: [
                  Color.fromRGBO(30, 30, 30, 1), // matches Palette.cardColor
                  Color.fromRGBO(42, 42, 55, 1), // slightly lifted dark tone
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: dialogBorderRadius ?? BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(251, 109, 169, 80),
            // Palette.gradient2 ~31%
            width: 1.2,
          ),
        ),
        padding: contentPadding ?? const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildBody(theme, spacing),
        ),
      ),
    );
  }

  /// Assembles the vertical list of sections respecting [imagePosition].
  List<Widget> _buildBody(ThemeData theme, double spacing) {
    final sections = <Widget>[];

    // Helper: image section (centred, with configurable padding)
    Widget imageSection() => Padding(
      padding: imagePadding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: image),
    );

    // Helper: text section (title + subtitle stacked)
    Widget? textSection() {
      if (title == null && subtitle == null) return null;
      return Column(
        children: [
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style:
                  titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    color: Palette.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
          if (title != null && subtitle != null) const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style:
                  subtitleStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: Palette.subtitleText,
                    height: 1.5,
                  ),
            ),
        ],
      );
    }

    // ── ImagePosition.aboveText  →  image first, then text ──
    if (imagePosition == ImagePosition.aboveText) {
      if (image != null) sections.add(imageSection());
      final text = textSection();
      if (text != null) {
        if (sections.isNotEmpty) sections.add(const SizedBox(height: 4));
        sections.add(text);
      }
    }
    // ── ImagePosition.belowText  →  text first, then image ──
    else {
      final text = textSection();
      if (text != null) sections.add(text);
      if (image != null) sections.add(imageSection());
    }

    // ── Buttons always at the bottom ──
    if (buttons.isNotEmpty) {
      sections
        ..add(const SizedBox(height: 8))
        ..add(_buildButtons(spacing));
    }

    return sections;
  }

  /// Builds the buttons section as a [Row] or [Column] depending on
  /// [buttonAxis] and whether a single full-width button is requested.
  Widget _buildButtons(double spacing) {
    if (buttons.isEmpty) return const SizedBox.shrink();

    // A single button, or explicit vertical axis → stacked full-width layout
    if (buttons.length == 1 || buttonAxis == Axis.vertical) {
      final children = <Widget>[];
      for (var i = 0; i < buttons.length; i++) {
        children.add(_buildSingleButton(buttons[i], forceFullWidth: true));
        if (i < buttons.length - 1) children.add(SizedBox(height: spacing));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    // Two or more buttons → side-by-side (horizontal) layout
    final children = <Widget>[];
    for (var i = 0; i < buttons.length; i++) {
      children.add(Expanded(child: _buildSingleButton(buttons[i])));
      if (i < buttons.length - 1) children.add(SizedBox(width: spacing));
    }
    return Row(children: children);
  }

  /// Renders a single [AppDialogButton] applying the correct visual style.
  ///
  /// - [forceFullWidth] overrides [AppDialogButton.fullWidth] to always
  ///   produce a full-width pill-shaped button (used for single-button dialogs
  ///   and vertical stacks).
  Widget _buildSingleButton(
    AppDialogButton btn, {
    bool forceFullWidth = false,
  }) {
    final isFullWidth = btn.fullWidth || forceFullWidth;
    final radius = BorderRadius.circular(isFullWidth ? 30 : 10);
    final minSize =
        isFullWidth ? const Size(double.infinity, 52) : const Size(0, 48);

    if (btn.isGradient) {
      // ── "Yes" / primary – gradient background, white bold text ──────────
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Palette.gradient1, Palette.gradient2],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: radius,
        ),
        child: ElevatedButton(
          onPressed: btn.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: minSize,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: radius),
          ),
          child: Text(
            btn.text,
            style: const TextStyle(
              color: Palette.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );
    } else {
      // ── "No" / secondary – white background, black bold text ─────────────
      return ElevatedButton(
        onPressed: btn.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.whiteColor,
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
          minimumSize: minSize,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: radius),
        ),
        child: Text(
          btn.text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      );
    }
  }
}
