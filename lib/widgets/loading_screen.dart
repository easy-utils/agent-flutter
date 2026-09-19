import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme/app_theme.dart';

/// Shared startup / loading surface.
///
/// One visual contract across all four clients (Flutter, WebUI, Compose,
/// SwiftUI) and, on the web, both the pre-engine splash in `index.html` and the
/// in-app loading phase:
///
///   * a centered rounded square MARK — each client's own two-letter mark
///     (Flutter `AF` #2563eb, WebUI `AW` #7c3aed, Compose `AC` #059669,
///     SwiftUI `AS` #d97706), 40dp, radius 10, semibold white letters;
///   * the app title (`Easy Agent`) below in the body text style;
///   * a 24dp progress ring under the title.
///
/// Keep this layout in sync with the other clients' splash markup.
class LoadingScreen extends StatelessWidget {
  /// Two-letter client mark drawn inside the tile (e.g. `AF`).
  final String mark;

  /// Mark tile background (the client's identity colour).
  final Color markColor;

  const LoadingScreen({
    super.key,
    this.mark = 'AF',
    this.markColor = const Color(0xFF2563eb),
  });

  @override
  Widget build(BuildContext context) {
    final c = colorsOf(context);
    final t = textOf(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: markColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                mark,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansMono',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(I18n.now.appTitle, style: t.body.copyWith(color: c.foreground)),
            const SizedBox(height: 16),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: c.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
