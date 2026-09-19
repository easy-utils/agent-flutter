import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'scope.dart';

const _kBase = 'base_url';
const _kToken = 'token';
// Tri-state theme pref ('system' | 'light' | 'dark'), default follow-system.
// Older installs stored the boolean dark_mode — it maps onto the explicit
// modes (never back to 'system': the user chose).
const _kTheme = 'theme_mode';
const _kDarkLegacy = 'dark_mode';
const _kBackends = 'backends';
const _kAgentLocale = 'agent_locale';
const _kReadWatermarks = 'read_watermarks';
const _kReadSeqs = 'read_seqs';

/// The connection scope the in-memory read watermarks belong to (empty until
/// [Prefs.loadReadScoped] runs). Part of the storage key so two users on the
/// same device never share unread state.
String readScope = '';

/// A session id → ISO timestamp of the last time the user opened it. Used to
/// derive the client-local unread dot (the agent does not track read state).
Map<String, String> readWatermarks = {};

/// A session id → the server `message_seq` the user had read when they last
/// opened it. The unread count is `messageSeq - readSeq` (client-local).
Map<String, int> readSeqs = {};

/// Agent prompt/tool language preference. 'follow' uses the UI language;
/// otherwise an explicit 'zh'/'en'.
String agentLocaleValue = 'follow';

/// A saved backend (gateway) the app can switch between.
class BackendCfg {
  final String name;
  final String baseUrl;
  final String token;
  const BackendCfg({
    required this.name,
    required this.baseUrl,
    required this.token,
  });

  Map<String, dynamic> toJson() =>
      {'name': name, 'baseUrl': baseUrl, 'token': token};
  factory BackendCfg.fromJson(Map<String, dynamic> j) => BackendCfg(
        name: j['name'] as String? ?? '',
        baseUrl: j['baseUrl'] as String? ?? '',
        token: j['token'] as String? ?? '',
      );

  /// Human label derived from the host when no explicit name exists.
  static String nameFor(String baseUrl) =>
      Uri.tryParse(baseUrl)?.host ?? baseUrl;
}

class Prefs {
  final String? baseUrl;
  final String? token;

  /// 'system' | 'light' | 'dark' (follow-system is the default).
  final String themeMode;
  const Prefs({this.baseUrl, this.token, this.themeMode = 'system'});

  static Future<Prefs> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final t = p.getString(_kTheme);
      final theme = (t == 'system' || t == 'light' || t == 'dark')
          ? t!
          : p.getBool(_kDarkLegacy) == true
              ? 'dark'
              : p.getBool(_kDarkLegacy) == false ? 'light' : 'system';
      return Prefs(baseUrl: p.getString(_kBase), token: p.getString(_kToken), themeMode: theme);
    } catch (_) {
      return const Prefs();
    }
  }

  static Future<void> save(String base, String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kBase, base);
    await p.setString(_kToken, token);
  }

  static Future<void> saveThemeMode(String mode) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kTheme, mode);
    } catch (_) {}
  }

  /// Resolve the effective agent locale for a request: explicit 'zh'/'en',
  /// else follow provided UI language.
  static Future<void> loadAgentLocale() async {
    try {
      final p = await SharedPreferences.getInstance();
      agentLocaleValue = p.getString(_kAgentLocale) ?? 'follow';
    } catch (_) {}
  }

  static Future<void> saveAgentLocale(String v) async {
    agentLocaleValue = v;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kAgentLocale, v);
    } catch (_) {}
  }

  /// Effective locale string to send to the agent ('zh'/'en').
  static String effectiveAgentLocale({required bool uiZh}) =>
      agentLocaleValue == 'follow'
          ? (uiZh ? 'zh' : 'en')
          : agentLocaleValue;

  /// Load the per-session read watermarks for the connection
  /// (baseUrl + token). Watermarks are keyed per scope: two users / two
  /// tenants on the same device must not share unread state.
  static Future<void> loadReadScoped(String baseUrl, String token) async {
    readScope = (baseUrl.isEmpty || token.isEmpty)
        ? ''
        : scopeOf(baseUrl, token);
    readWatermarks = {};
    readSeqs = {};
    if (readScope.isEmpty) return;
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString('${_kReadWatermarks}_$readScope');
      if (raw != null && raw.isNotEmpty) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        readWatermarks = {
          for (final e in j.entries) e.key: '${e.value}',
        };
      }
      final rawSeqs = p.getString('${_kReadSeqs}_$readScope');
      if (rawSeqs != null && rawSeqs.isNotEmpty) {
        final j2 = jsonDecode(rawSeqs) as Map<String, dynamic>;
        readSeqs = {
          for (final e in j2.entries)
            e.key: (e.value is num) ? (e.value as num).toInt() : 0,
        };
      }
    } catch (_) {}
  }

  static String get _wmKey =>
      readScope.isEmpty ? _kReadWatermarks : '${_kReadWatermarks}_$readScope';

  static String get _seqKey =>
      readScope.isEmpty ? _kReadSeqs : '${_kReadSeqs}_$readScope';

  /// Record that [sessionId] was opened now (clears its unread dot/count).
  static Future<void> markRead(String sessionId, String atIso,
      {int? readSeq}) async {
    readWatermarks[sessionId] = atIso;
    if (readSeq != null) readSeqs[sessionId] = readSeq;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_wmKey, jsonEncode(readWatermarks));
      if (readSeq != null) {
        await p.setString(_seqKey, jsonEncode(readSeqs));
      }
    } catch (_) {}
  }

  /// Persist the current read-seq map (used to seed historical sessions).
  static Future<void> saveReadSeqs() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_seqKey, jsonEncode(readSeqs));
    } catch (_) {}
  }

  /// Log out of the ACTIVE backend only (locale, dark mode and the saved
  /// backend list stay so switching back is one tap).
  static Future<void> clearActive() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_kBase);
      await p.remove(_kToken);
    } catch (_) {}
  }

  /// All saved backends (name+url+token), order preserved.
  static Future<List<BackendCfg>> backends() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_kBackends);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List? ?? [];
      return list
          .map((e) => BackendCfg.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Upserts [b] into the saved list, keyed by the FULL connection identity
  /// (baseUrl + token): one gateway host may serve several tenants, so the
  /// same baseUrl with a different token is a distinct saved user.
  static Future<void> upsertBackend(BackendCfg b) async {
    final list = [...await backends()];
    list.removeWhere((x) => x.baseUrl == b.baseUrl && x.token == b.token);
    list.insert(0, b);
    await _writeBackends(list);
  }

  static Future<void> removeBackend(BackendCfg b) async {
    final list = [...await backends()];
    list.removeWhere((x) => x.baseUrl == b.baseUrl && x.token == b.token);
    await _writeBackends(list);
  }

  static Future<void> _writeBackends(List<BackendCfg> list) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(
          _kBackends, jsonEncode(list.map((b) => b.toJson()).toList()));
    } catch (_) {}
  }
}
