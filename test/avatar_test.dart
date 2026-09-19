import 'package:agent_app/widgets/chat_avatar.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// The (hue, bg, fg) golden table produced by tools/avatars.py; all four
/// clients must render exactly these 8-bit channels.
const vectors = <String, (int, int, int, int, int, int, int)>{
  'e2e-gwchat': (316, 196, 49, 157, 50, 12, 39),
  'test': (357, 196, 49, 56, 245, 214, 215),
  'hello': (243, 56, 49, 196, 168, 164, 234),
};

void main() {
  test('chat avatar colours match the golden vectors', () {
    for (final e in vectors.entries) {
      final spec = debugAvatarSpec(e.key);
      final bg = spec.$1, fg = spec.$2;
      expect(spec.$3, e.value.$1, reason: '${e.key} hue');
      expect((bg.r * 255).round(), e.value.$2, reason: '${e.key} bg.r');
      expect((bg.g * 255).round(), e.value.$3, reason: '${e.key} bg.g');
      expect((bg.b * 255).round(), e.value.$4, reason: '${e.key} bg.b');
      expect((fg.r * 255).round(), e.value.$5, reason: '${e.key} fg.r');
      expect((fg.g * 255).round(), e.value.$6, reason: '${e.key} fg.g');
      expect((fg.b * 255).round(), e.value.$7, reason: '${e.key} fg.b');
    }
  });
}
