import 'dart:convert';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../icons.dart';

/// The tool-call card glyph: ONE icon + ONE colour for every tool family, so
/// the card looks identical whatever the tool. The only per-tool text is the
/// tool name / title in the header. (Status — running/error/complete — is
/// still distinguished by the separate header dot.)
class ToolIcon extends StatelessWidget {
  final String name;
  const ToolIcon(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(AppIcons.tools, size: 14, color: colorsOf(context).primary);
  }
}

String toolDisplayName(String t) {
  const map = {'todowrite': 'todo'};
  return map[t] ?? t;
}

String fmtOutput(Object? raw) {
  if (raw == null) return '';
  return raw is String ? raw : _pretty(raw);
}

String _pretty(Object o) {
  if (o is Map || o is List) {
    const enc = JsonEncoder.withIndent('  ');
    return enc.convert(o);
  }
  return o.toString();
}
